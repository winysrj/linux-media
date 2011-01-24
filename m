Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55557 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1AXTpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 14:45:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [RFC] ISP lane shifter support
Date: Mon, 24 Jan 2011 20:45:24 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D394675.90304@matrix-vision.de> <201101241457.44866.laurent.pinchart@ideasonboard.com> <4D3D89BC.8070305@matrix-vision.de>
In-Reply-To: <4D3D89BC.8070305@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101242045.24561.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Monday 24 January 2011 15:16:28 Michael Jones wrote:
> On 01/24/2011 02:57 PM, Laurent Pinchart wrote:
> <snip>
> 
> >>> As the lane shifter is located at the CCDC input, it might be easier to
> >>> implement support for this using the CCDC input format. ispvideo.c
> >>> would need to validate the pipeline when the output of the entity
> >>> connected to the CCDC input (parallel sensor, CCP2 or CSI2) is
> >>> configured with a format that can be shifted to the format at the CCDC
> >>> input.
> >> 
> >> This crossed my mind, but it seems illogical to have a link with a
> >> different format at each of its ends.
> > 
> > I agree in theory, but it might be problematic for the CCDC. Right now
> > the CCDC can write to memory or send the data to the preview engine, but
> > not both at the same time. That's something that I'd like to change in
> > the future. What happens if the user then sets different widths on the
> > output pads ?
> 
> Shouldn't we prohibit the user from doing this in ccdc_[try/set]_format
> in the first place? By "prohibit", I mean shouldn't we be sure that the
> pixel format on pad 1 is always the same as on pad 2?

Yes we should (although we could have a larger width on the memory write port, 
as the video port can further shift the data).

> Downside: this suggests that set_fmt on pad 2 could change the fmt on pad 1,
> which may be unexpected. But that does at least reflect the reality of the
> hardware, right?

I don't think it would be a good idea to silently change formats on pad 1 when 
setting the format on pad 2. Applications don't expect that. That's why I've 
proposed changing the format on pad 0 instead. I agree that it would be better 
to have the same format on the sensor output and on CCDC pad 0 though.

-- 
Regards,

Laurent Pinchart
