Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36729 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754129AbdCFRHs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 12:07:48 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 1/4] v4l: vsp1: Implement partition algorithm restrictions
References: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <87tw7dn3aj.wl%kuninori.morimoto.gx@renesas.com>
 <87tw772apo.wl%kuninori.morimoto.gx@renesas.com> <5537374.FMr42qi89O@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <7bd0ad04-6984-e576-c526-bed388c26c6d@ideasonboard.com>
Date: Mon, 6 Mar 2017 17:07:42 +0000
MIME-Version: 1.0
In-Reply-To: <5537374.FMr42qi89O@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Morimoto-san,

On 06/03/17 15:16, Laurent Pinchart wrote:
> Hi Morimoto-san,
> 
> On Monday 06 Mar 2017 06:17:47 Kuninori Morimoto wrote:
>> Hi Laurent, Kieran
>>
>>>>
>>>> I asked it to HW team.
>>>> Please wait
>>
>> I'm still waiting from HW team's response, but can you check
>> "32.3.7 Image partition for VSPI processing" on v0.53 datasheet ?
>> (v0.53 is for ES2.0, but this chapter should be same for ES1.x / ES2.0)
>> You may / may not find something from here
> 
> That's very detailed, good job of the documentation writers ! Please thank 
> them for me if you know who they are :-)
> 
> I'm sure we will find useful information there. Kieran, could you please have 
> a look when you'll be back at the end of this week, and list the points that 
> you think we don't address correctly yet ?
> 

No, I'm afraid I can not. :-D

I have
 R-Car-Gen3-rev0.51e.pdf
and
 R-Car-Gen3-rev0.52E.pdf

Neither of these files has a section
"32.3.7 Image partition for VSPI processing"

If I find a link to a new version of the datasheet in my inbox then I will
certainly consider changing my decision ;-)

--
Regards

Kieran
