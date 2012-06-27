Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58786 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2F0PK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 11:10:27 -0400
Received: from eusync2.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6A00C827I79D40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 16:10:55 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M6A0059G7HCJH50@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 16:10:25 +0100 (BST)
Message-id: <4FEB2260.9070107@samsung.com>
Date: Wed, 27 Jun 2012 17:10:24 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v3] media: Add stk1160 new driver
References: <1340476571-10832-1-git-send-email-elezegarcia@gmail.com>
 <4FE8D38B.2090700@gmail.com>
 <CALF0-+VAqbYcGZ0X9ZxX4H8LsD2mt3Oi=WtW82k01hN2T3gh+w@mail.gmail.com>
In-reply-to: <CALF0-+VAqbYcGZ0X9ZxX4H8LsD2mt3Oi=WtW82k01hN2T3gh+w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/27/2012 04:40 PM, Ezequiel Garcia wrote:
> Hi Sylwester,
> 
> I'm OK with every comment you made.
> 
> Except for the -ETIMEDOUT.
> I'm still not 100% convinced, but I'll take your word for it.

It looked most appropriate to me, however I didn't really analyse
very deeply the whole driver to see how it would have been propagated.
That's just a humble suggestion.

Good luck with those works! :)

---
Regards,
Sylwester
