Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57301 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1DHMu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 08:50:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: vb2: stop_streaming() callback redesign
Date: Fri, 8 Apr 2011 14:50:21 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, g.liakhovetski@gmx.de
References: <1301874670-14833-1-git-send-email-pawel@osciak.com> <201104041227.30262.laurent.pinchart@ideasonboard.com> <BANLkTikBhDkmngtmjfz=Ze2c8Rj6zeVKvg@mail.gmail.com>
In-Reply-To: <BANLkTikBhDkmngtmjfz=Ze2c8Rj6zeVKvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081450.28472.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Pawel,

On Tuesday 05 April 2011 17:12:29 Pawel Osciak wrote:
> On Mon, Apr 4, 2011 at 03:27, Laurent Pinchart wrote:
> > On Monday 04 April 2011 01:51:05 Pawel Osciak wrote:
> >> Hi,
> >> 
> >> This series implements a slight redesign of the stop_streaming()
> >> callback in vb2. The callback has been made obligatory. The drivers are
> >> expected to finish all hardware operations and cede ownership of all
> >> buffers before returning, but are not required to call
> >> vb2_buffer_done() for any of them. The return value from this callback
> >> has also been removed.
> > 
> > What's the rationale behind this patch set ? I've always been against vb2
> > controlling the stream state (vb2 should handle buffer management only in
> > my opinion) and I'd like to understand why you want to make it required.
> 
> I might have overstated the intention saying it was a 'redesign'. It
> actually doesn't change the overall stop_streaming callback idea, I am
> just simplifying it with this patch, while also emphasizing its role
> by making it obligatory. Drivers were always required to finish
> everything they were doing with the buffers before returning from
> stop_streaming. But until now, stop_streaming was expecting the driver
> to call vb2_buffer_done for all buffers it received via buf_queue.
> We've decided it's superfluous, so I am removing this requirement.
> Also, I didn't see any use for the return value from stop_streaming so
> I removed it as well. Apart from the above, nothing has really
> changed.

Does that mean that drivers don't have to implement the stop_streaming 
callback if they finish all buffer-related operations before calling vb2 
functions that stop streaming ?

> > I plan to use vb2 in the uvcvideo driver (when vb2 will provide a way to
> > handle device disconnection), and uvcvideo will stop the stream before
> > calling vb2_queue_release() and vb2_streamoff(). Would will I need a
> > stop_stream operation ?
> 
> I actually just yesterday noticed your response from a couple of weeks ago
> to my comments to your original buf_queue proposal in my ever growing pile
> of mail, sorry about that, I will reply to that as soon as I have time to
> properly read it and think about it. Nevertheless, I have the same question
> as Marek here, would there be anything preventing you from doing that in
> stop_streaming?

See my reply to Marek :-)

-- 
Regards,

Laurent Pinchart
