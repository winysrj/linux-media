Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:2476 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0AFDCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 22:02:03 -0500
Received: by fg-out-1718.google.com with SMTP id 19so6924472fgg.1
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2010 19:02:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B43CD2A.7080604@chello.at>
References: <4B437BFE.7040003@chello.at>
	 <829197381001051014s42766227i6496437d2c557607@mail.gmail.com>
	 <4B43CD2A.7080604@chello.at>
Date: Tue, 5 Jan 2010 22:02:01 -0500
Message-ID: <829197381001051902wdf00cbbnffe6149401d3fd21@mail.gmail.com>
Subject: Re: PROBLEM: DVB-T scan not working after ioctl
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?B?RnJhbnogRvxyYmHf?= <franz.fuerbass@chello.at>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 5, 2010 at 6:37 PM, Franz Fürbaß <franz.fuerbass@chello.at> wrote:
> Ok, seems to work. I put an usleep(5000000); between close and open.
> I will try to apply this to MythTV and w_scan as well.

You can certainly try that with w_scan and MythTV to see if it
improves your situation.  However, I want to be clear that I just
wanted you to do it for testing purposes to see if it helps, and it
likely suggests a bug in the kernel that will need to be fixed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
