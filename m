Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab0AZWZC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 17:25:02 -0500
Message-ID: <4B5F6BB9.4000203@redhat.com>
Date: Tue, 26 Jan 2010 20:24:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How can I add IR remote to this new device (DIKOM DK300)?
References: <4B51132A.1000606@gmail.com> <4B5D912F.6000609@redhat.com> <4B5F6914.4080502@gmail.com>
In-Reply-To: <4B5F6914.4080502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrea.Amorosi76@gmail.com wrote:
 
> So since it is necessary to create a new entry, is there any rules to
> follow to choose it?

Just use the existing entry as an example. You'll need to put your
card name at the entry, and add a new #define at em28xx.h.

Cheers,
Mauro
