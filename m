Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44626 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754005AbcLNRxa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 12:53:30 -0500
Subject: Re: [PATCHv3 RFC 4/4] media: Catch null pipes on pipeline stop
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1481651984-7687-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <20161214072843.GA16630@valkosipuli.retiisi.org.uk>
 <9594fc25-c657-7326-0987-9a7bc1bc888f@bingham.xyz>
 <20161214124324.GB16630@valkosipuli.retiisi.org.uk>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <aac63f53-e011-531a-7d6a-4832b9faee07@ideasonboard.com>
Date: Wed, 14 Dec 2016 17:53:00 +0000
MIME-Version: 1.0
In-Reply-To: <20161214124324.GB16630@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 14/12/16 12:43, Sakari Ailus wrote:
> Hi Kieran,
> 
> On Wed, Dec 14, 2016 at 12:27:37PM +0000, Kieran Bingham wrote:
>> Hi Sakari,
>>
>> On 14/12/16 07:28, Sakari Ailus wrote:
>>> Hi Kieran,
>>>
>>> On Tue, Dec 13, 2016 at 05:59:44PM +0000, Kieran Bingham wrote:
>>>> media_entity_pipeline_stop() can be called through error paths with a
>>>> NULL entity pipe object. In this instance, stopping is a no-op, so
>>>> simply return without any action
>>>
>>> The approach of returning silently is wrong; the streaming count is indeed a
>>> count: you have to decrement it the exactly same number of times it's been
>>> increased. Code that attempts to call __media_entity_pipeline_stop() on an
>>> entity that's not streaming is simply buggy.
>>
>> Ok, Thanks for the heads up on where to look, as I suspected we are in
>> section B) of my comments below :D
>>
>>> I've got a patch here that adds a warning to graph traversal on streaming
>>> count being zero. I sent a pull request including that some days ago:
>>>
>>> <URL:http://www.spinics.net/lists/linux-media/msg108980.html>
>>> <URL:http://www.spinics.net/lists/linux-media/msg108995.html>
>>
>> Excellent, thanks, I've merged your branch into mine, and I'll
>> investigate where the error is actually coming from.
>>
>> --
>> Ok - so I've merged your patches, (and dropped this patch) but they
>> don't fire any warning before I hit my null-pointer dereference in
>> __media_pipeline_stop(), on the WARN_ON(!pipe->streaming_count);
>>
>> So I think this is a case of calling stop on an invalid entity rather
>> than an unbalanced start/stop somehow:
> 
> Not necessarily. The pipe is set to NULL if the count goes to zero.
> 
> This check should be dropped, it's ill-placed anyway: if streaming count is
> zero the pipe is expected to be NULL anyway in which case you get a NULL
> pointer exception (that you saw there). With the check removed, you should
> get the warning instead.

Ahh, yes, I'd missed the part there that was setting it to NULL.

However, it will still segfault ... (though hopefully after the warning)
as the last line of the function states:

	if (!--pipe->streaming_count)
		media_entity_graph_walk_cleanup(graph);

So we will hit a null deref on the pipe->streaming_count there, which
still leaves an unbalanced stop as a kernel panic.

In fact, I've just tested removing that WARN_ON(!pipe->streaming_count);
 - it doesn't even get that far - and segfaults in

 		media_entity_graph_walk_cleanup(graph);

[   80.916558] Unable to handle kernel NULL pointer dereference at
virtual address 00000110
....
[   81.769492] [<ffffff800853e278>] media_graph_walk_start+0x20/0xf0
[   81.776615] [<ffffff800853e73c>] __media_pipeline_stop+0x3c/0xd8
[   81.783644] [<ffffff800853e80c>] media_pipeline_stop+0x34/0x48
[   81.790505] [<ffffff8008567ff0>] vsp1_du_setup_lif+0x68/0x5a8
[   81.797279] [<ffffff80084de9d4>] rcar_du_vsp_disable+0x2c/0x38
[   81.804137] [<ffffff80084da710>] rcar_du_crtc_stop+0x198/0x1e8
[   81.810984] [<ffffff80084da780>] rcar_du_crtc_disable+0x20/0x38

due to the fact that 'graph' is dereferenced through the 'pipe'.

{
	/* Entity->pipe is NULL, therefore 'graph' is invalid */
	struct media_graph *graph = &entity->pipe->graph;
	struct media_pipeline *pipe = entity->pipe;

	media_graph_walk_start(graph, entity);
...
}

So I suspect we do still need a warning or check in there somewhere.
Something to tell the developer that there is an unbalanced stop, would
be much better than a panic/segfault...

(And of course, we still need to look at the actual unbalanced stop in
vsp1_du_setup_lif!)

--
Kieran
