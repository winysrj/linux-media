Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0BJXPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 18:15:10 -0500
Message-ID: <4B733DF9.9080201@infradead.org>
Date: Wed, 10 Feb 2010 21:15:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: add Dikom DK300 hybrid USB tuner
References: <4AFE92ED.2060208@gmail.com> <4AFEAB15.9010509@gmail.com> <829197380911140634j49c05cd0s90aed57b9ae61436@mail.gmail.com> <4B71ACC8.600@gmail.com> <4B71B5BD.8090006@infradead.org> <4B71CB52.4080109@gmail.com>
In-Reply-To: <4B71CB52.4080109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrea.Amorosi76@gmail.com wrote:

I had to fix small merging conflicts.

> +        .valid        = EM28XX_BOARD_NOT_VALIDATED,

Also, you tested the board, so, I'm removing the .valid tag.

Cheers,
Mauro
