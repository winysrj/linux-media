Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2002 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaDKHuj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 03:50:39 -0400
Message-ID: <53479EB6.80504@xs4all.nl>
Date: Fri, 11 Apr 2014 09:50:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Cookson - IT <it@sca-uk.com>, linux-media@vger.kernel.org
Subject: Re: List objectives and interests.
References: <53479D15.4000400@sca-uk.com>
In-Reply-To: <53479D15.4000400@sca-uk.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On 04/11/2014 09:43 AM, Steve Cookson - IT wrote:
> Hi People,
> 
> Could I, please, I clarify what the purposes of this list are?
> 
> I am developing a system to collect medical raw video based on Linux.  I 
> have tested a number of SD and HD adaptors for this project some of 
> which have worked to a greater or lesser extent.
> 
> Is this the right place for peer-based support for video capture?
> 
> I know that SD is a bit old and maybe there is no longer much demand for 
> it, in which case I could move to an HD adaptor, but there also doesn't 
> seem to be much out there on Linux to capture raw HD either.
> 
> So is this list really about Linux TV rather than video capture more 
> generally?
> 
> Is there a more appropriate list to ask questions about raw video capture?

No, this is the right list for that. The linux-media mailinglist is for
developers and users of anything under drivers/media in the kernel tree.

With regards to HD: while HD is well supported for embedded systems, there
are really no V4L2 drivers for consumer HDTV capture boards. The closest is
an out-of-tree driver for a DVI capture board (Osprey 820e), but there is
nothing for HDMI capture.

Regards,

	Hans

> Any help or pointers very gratefully received.
> 
> Regards
> 
> Steve.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

