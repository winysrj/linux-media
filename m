Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bonissi.it ([185.12.14.237]:39448 "EHLO mail.bonissi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776AbbA1A2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 19:28:30 -0500
Received: from [10.0.0.70] (dynamic-adsl-94-36-253-42.clienti.tiscali.it [94.36.253.42])
	(authenticated bits=0)
	by vps.bonissi.it (8.14.4/8.14.4) with ESMTP id t0RNYV1e000452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 28 Jan 2015 00:34:32 +0100
Message-ID: <54C82130.4070005@scarsita.it>
Date: Wed, 28 Jan 2015 00:37:20 +0100
From: Luca Bonissi <lucabon@scarsita.it>
MIME-Version: 1.0
To: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: gspca_vc032x - wrong bytesperline
References: <54C61919.7050508@scarsita.it>
In-Reply-To: <54C61919.7050508@scarsita.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, forgot to include related link to kernel bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=91181

Ciao!
  Luca

On 26/01/2015 11:38, Luca Bonissi wrote:
> Hi!
> 
> I found a problem on vc032x gspca usb webcam subdriver: "bytesperline"
> property is wrong for YUYV and YVYU formats.
> With recent v4l-utils library (>=0.9.1), that uses "bytesperline" for
> pixel format conversion, the result is a wrong jerky image.
> 
> Patch tested on my laptop (USB webcam Logitech Orbicam 046d:0892).
> 
