Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4161 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZHaSEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 14:04:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: hvr-1800 disabling audio on pvr-500?
Date: Mon, 31 Aug 2009 20:04:38 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <86BDC1B0-F181-4D45-AD8D-2D836EE998CB@wilsonet.com>
In-Reply-To: <86BDC1B0-F181-4D45-AD8D-2D836EE998CB@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908312004.38112.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 31 August 2009 19:45:08 Jarod Wilson wrote:
> Haven't verified this myself, but there's a bugzilla ticket filed w/ 
> Red Hat, claiming that audio on a pvr-500 is disabled when its in the  
> same system as an hvr-1800.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=480728
> 
> Nonsense? Already fixed? Report says it worked fine in 2.6.25, broke  
> in 2.6.27, not sure if later kernels have been tried. If its already  
> fixed, and someone happens to know the commit that fixed it, I'd  
> appreciate a pointer...
> 

Urgh. cx25840_loadfw() in cx25840_firmware.c contains this code:

        if (state->is_cx23885)
                firmware = FWFILE_CX23885;
        else if (state->is_cx231xx)
                firmware = FWFILE_CX231XX;

Unfortunately firmware is a global string module option, initially setup to
contain the 'normal' cx25840 firmware name.

So loading a cx23885 or a cx231xx will overwrite that string and if ivtv is
loaded afterwards it tries to load the wrong firmware.

Sigh...

I'll see if I have time to fix this today or tomorrow.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
