Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40001 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaANUuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 15:50:06 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so456743eek.39
        for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 12:50:04 -0800 (PST)
Message-ID: <52D5A344.5060000@googlemail.com>
Date: Tue, 14 Jan 2014 21:51:16 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/7] em28xx-audio: remove a deplock circular dependency
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-6-git-send-email-m.chehab@samsung.com> <52D45FC4.10106@googlemail.com> <20140114134541.1e1f2469@samsung.com> <52D58569.3000405@googlemail.com> <20140114175907.407c0d16@samsung.com>
In-Reply-To: <20140114175907.407c0d16@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.01.2014 20:59, schrieb Mauro Carvalho Chehab:
>> After thinking about this for a while:
>> > Does your patch
>> > 
>> > [PATCH] em28xx: push mutex down to extensions on .fini callback
>> > 
>> > which you've sent afterwards fix this warning, too ?
> Yes, the above patch fixed the circular lock issues.
Ok, great, one problem less. :-)
