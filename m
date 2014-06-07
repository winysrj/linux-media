Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:55258 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753070AbaFGPz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jun 2014 11:55:28 -0400
Message-ID: <1402156524.28369.4.camel@joe-AO725>
Subject: Re: [PATCH] media-device: Remove duplicated memset() in
 media_enum_entities()
From: Joe Perches <joe@perches.com>
To: Salva =?ISO-8859-1?Q?Peir=F3?= <speiro@ai2.upv.es>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
Date: Sat, 07 Jun 2014 08:55:24 -0700
In-Reply-To: <1402152104-16865-1-git-send-email-speiro@ai2.upv.es>
References: <1402152104-16865-1-git-send-email-speiro@ai2.upv.es>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2014-06-07 at 16:41 +0200, Salva Peiró wrote:
> After the zeroing the whole struct struct media_entity_desc u_ent,
> it is no longer necessary to memset(0) its u_ent.name field.

trivia:

> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
[]
> @@ -106,8 +106,6 @@ static long media_device_enum_entities(struct media_device *mdev,
>  	if (ent->name) {
>  		strncpy(u_ent.name, ent->name, sizeof(u_ent.name));
>  		u_ent.name[sizeof(u_ent.name) - 1] = '\0';

this could be strlcpy too.



