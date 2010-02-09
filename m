Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49353 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab0BIFSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 00:18:33 -0500
Received: by bwz19 with SMTP id 19so471104bwz.28
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 21:18:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B70E7DB.7060101@cooptel.qc.ca>
References: <4B70E7DB.7060101@cooptel.qc.ca>
Date: Tue, 9 Feb 2010 00:18:31 -0500
Message-ID: <829197381002082118k346437b3y4dc2eb76d017f24f@mail.gmail.com>
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
	(DVB-S) and USB HVR Hauppauge 950q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Richard Lemieux <rlemieu@cooptel.qc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 8, 2010 at 11:43 PM, Richard Lemieux <rlemieu@cooptel.qc.ca> wrote:
> Hi,
>
> I got some driver crashes after upgrading to kernel 2.6.32.7.  It seems that
> activating either TBS8920 (DVB-S) and HVR950Q (ATSC) after the other one has
> run (and is no longer in use by an application) triggers a driver crash.

Hello Richard,

Have you tried any other kernel version?  For example, do you know
that it works properly in 2.6.32.6?

Can you bisect and see when the problem was introduced?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
