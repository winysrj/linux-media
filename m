Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:51956 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZKGMXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 07:23:38 -0500
Message-ID: <4AF566CD.4060308@freemail.hu>
Date: Sat, 07 Nov 2009 13:23:41 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca pac7302: add red and blue balance control
References: <4AF55BE8.2090608@freemail.hu>
In-Reply-To: <4AF55BE8.2090608@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Németh Márton wrote:
> Add the red and blue balance control to the pac7302 driver. The valid
> values for these controls are 0..3 which was identified by trial and error
> on Labtec Webcam 2200 (USB ID 093a:2626). The upper 5 bits are ignored

The upper 6 bits, I mean. The lower two bits are only used for value.

Regards,

	Márton Németh
