Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34064 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731237AbeKWG1j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 01:27:39 -0500
Subject: Re: Bug in stkwebcam?
To: Andreas Pape <ap@ca-pape.de>
References: <20181122202341.bddc151d82ce2cb7bb29a61b@ca-pape.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <99f05e35-a66b-8bf0-4c9f-91c5197f53fc@ideasonboard.com>
Date: Thu, 22 Nov 2018 19:46:44 +0000
MIME-Version: 1.0
In-Reply-To: <20181122202341.bddc151d82ce2cb7bb29a61b@ca-pape.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On 22/11/2018 19:23, Andreas Pape wrote:
> Hello,
> 
> I recently updated my old 2006 Asus A6VM notebook with the latest 32bit
> Ubuntu 18.04 LTS (kernel 4.15.0) and found out that the driver for the
> webcam (Syntek USB2.0, USB ID 174f:a311) was not working. I only got error
> messages like "Sensor resetting failed" in dmesg when starting guvcview
> for example.
> 
> Far from being an expert for video devices, I tried to debug this and
> figured out three patches to make the webcam work again on my old notebook
> (at least I get a video again ;-).

Excellent - that sounds like you've worked out the hard part :-)


> I know the type of notebook and webcam is pretty old and the driver seems
> not to be actively maintained anymore although still being part of actual
> kernel versions.
> 
> Is there still an interest in getting patches for such an old device? If
> yes, I could try to rebase my patches to the actual version of media_tree.git
> and post them to the mailing list.

If it's a USB webcam, then it could be plugged into any newer PC/Laptop
too, so I would say there is still merit in identifying the fault and
fixing it if feasible.

I don't think it would hurt to send the patches at least.

Feel free to CC me when you do.

Regards
--
Kieran


> Kind regards,
> Andreas
> 
