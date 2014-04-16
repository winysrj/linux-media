Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39085 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaDPNZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 09:25:10 -0400
Received: by mail-qc0-f176.google.com with SMTP id m20so11768438qcx.7
        for <linux-media@vger.kernel.org>; Wed, 16 Apr 2014 06:25:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <534E839C.6060203@xs4all.nl>
References: <534675E1.6050408@sca-uk.com>
	<5347B132.6040206@sca-uk.com>
	<5347B9A3.2050301@xs4all.nl>
	<5347BDDE.6080208@sca-uk.com>
	<5347C57B.7000207@xs4all.nl>
	<5347DD94.1070000@sca-uk.com>
	<5347E2AF.6030205@xs4all.nl>
	<5347EB5D.2020408@sca-uk.com>
	<5347EC3D.7040107@xs4all.nl>
	<5348392E.40808@sca-uk.com>
	<534BEA8A.2040604@xs4all.nl>
	<534D6241.5060903@sca-uk.com>
	<534D68C2.6050902@xs4all.nl>
	<534D7E24.4010602@sca-uk.com>
	<534E5438.3030404@xs4all.nl>
	<534E8225.6090804@sca-uk.com>
	<534E839C.6060203@xs4all.nl>
Date: Wed, 16 Apr 2014 09:25:10 -0400
Message-ID: <CAGoCfiwMzQij8uaksshZH+q62kGJoOwKGHxiYhS0kk+KdtMK_A@mail.gmail.com>
Subject: Re: Hauppauge ImpactVCB-e 01385
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Cookson <it@sca-uk.com>, Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Anyway, I would recommend that you make a safety copy of your modules
> first (just in case :-) ), and then move all the newly install modules
> to the right place.

Yeah, I generally recommend that in such cases you just "rm -rf
/lib/modules/`uname -r`/kernel/drivers/media" before running "make
install", so you know you're in a clean state (make a backup copy
first though, just in case).  This avoids having to figure out which
driver moved and the old version of which didn't get deleted.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
