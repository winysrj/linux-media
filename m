Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:13033 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbJWJO2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 05:14:28 -0400
Date: Fri, 23 Oct 2015 11:13:56 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	moinejf@free.fr, Anders Blomdell <anders.blomdell@control.lth.se>,
	Thomas Champagne <lafeuil@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] [media] gspca: ov534/topro: prevent a division by 0
Message-Id: <20151023111356.f76b8ec65a91baa2df8a9d36@ao2.it>
In-Reply-To: <560F8E59.4090104@redhat.com>
References: <1443817993-32406-1-git-send-email-ao2@ao2.it>
	<560F8E59.4090104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 3 Oct 2015 10:14:17 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
>

Hi HdG,

> On 02-10-15 22:33, Antonio Ospite wrote:
[...]
> > Signed-off-by: Antonio Ospite <ao2@ao2.it>
> > Cc: stable@vger.kernel.org
> 
> Good catch:
> 
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> 
> Mauro can you pick this one up directly, and include it in your
> next pull-req for 4.3 please ?
> 

Ping.

On https://patchwork.linuxtv.org/patch/31561/ it says:
Delegated to: 	Hans de Goede

Who is going to handle this?

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
