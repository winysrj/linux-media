Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:30770 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3H0H0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 03:26:16 -0400
Message-ID: <521C5493.1050407@cisco.com>
Date: Tue, 27 Aug 2013 09:26:11 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Knut Petersen <Knut_Petersen@t-online.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [REGRESSION 3.11-rc] wm8775 9-001b: I2C: cannot write ??? to
 register R??
References: <521A269D.3020909@t-online.de>
In-Reply-To: <521A269D.3020909@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2013 05:45 PM, Knut Petersen wrote:
> Booting current git kernel dmesg shows a set of new  warnings:
> 
>     "wm8775 9-001b: I2C: cannot write ??? to register R??"
> 
> Nevertheless, the hardware seems to work fine.
> 
> This is a new problem, introduced after kernel 3.10.
> If necessary I can bisect.

Can you try this patch? I'm pretty sure this will fix it.

Regards,

	Hans

diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index afe0eae..28893a6 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -259,7 +259,7 @@ struct cx88_input {
 };
 
 enum cx88_audio_chip {
-	CX88_AUDIO_WM8775,
+	CX88_AUDIO_WM8775 = 1,
 	CX88_AUDIO_TVAUDIO,
 };
 

