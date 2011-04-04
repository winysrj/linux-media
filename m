Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40370 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1DDK07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 06:26:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: vb2: stop_streaming() callback redesign
Date: Mon, 4 Apr 2011 12:27:29 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, g.liakhovetski@gmx.de
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
In-Reply-To: <1301874670-14833-1-git-send-email-pawel@osciak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104041227.30262.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Pawel,

On Monday 04 April 2011 01:51:05 Pawel Osciak wrote:
> Hi,
> 
> This series implements a slight redesign of the stop_streaming() callback
> in vb2. The callback has been made obligatory. The drivers are expected to
> finish all hardware operations and cede ownership of all buffers before
> returning, but are not required to call vb2_buffer_done() for any of them.
> The return value from this callback has also been removed.

What's the rationale behind this patch set ? I've always been against vb2 
controlling the stream state (vb2 should handle buffer management only in my 
opinion) and I'd like to understand why you want to make it required.

I plan to use vb2 in the uvcvideo driver (when vb2 will provide a way to 
handle device disconnection), and uvcvideo will stop the stream before calling 
vb2_queue_release() and vb2_streamoff(). Would will I need a stop_stream 
operation ?

-- 
Regards,

Laurent Pinchart
