Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:35951 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHJVeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 17:34:21 -0400
Received: by mail-qc0-f175.google.com with SMTP id w7so993239qcr.6
        for <linux-media@vger.kernel.org>; Sun, 10 Aug 2014 14:34:21 -0700 (PDT)
Received: from [192.168.0.35] (cpe-071-077-206-066.ec.res.rr.com. [71.77.206.66])
        by mx.google.com with ESMTPSA id r91sm11710647qgd.12.2014.08.10.14.34.17
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 10 Aug 2014 14:34:20 -0700 (PDT)
In-Reply-To: <15fe468e-0c2e-4b81-8a4e-6e3529e57046@email.android.com>
References: <15fe468e-0c2e-4b81-8a4e-6e3529e57046@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Fwd: Re: CX23885 error during boot
From: Andy Walls <andy@silverblocksystems.net>
Date: Sun, 10 Aug 2014 17:34:01 -0400
To: linux-media@vger.kernel.org
Message-ID: <108ecfec-d9ba-4f7f-b9f0-155905338e16@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




>
>Dear Media Community:
>  Since switching to CentOS7 and the 3.10.0-123 kernel as listed below:
>> Linux mythbox.lightfoot.us 3.10.0-123.6.3.el7.x86_64 #1 SMP Wed Aug
>> 6 21:12:36 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
>	I keep getting the following in dmesg related to my Hauppage Video
>Card at bootup.  The error seems to have no affect on operation, but I
>am curious if there is something to be done to resolve it?

You have the wrong firmware image for the CX23417 MPEG encoder chip connected to the CX23885.  Update it to the proper file.  If you dont use the card for compressed analog video, it doesnt matter.

Regards,
Andy
