Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab2ASN6w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 08:58:52 -0500
Message-ID: <4F182197.4090407@redhat.com>
Date: Thu, 19 Jan 2012 11:58:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] keytable: Fix copy and paste error for SANYO IR protocol
References: <1326980563-8194-1-git-send-email-gjasny@googlemail.com> <1326980563-8194-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1326980563-8194-2-git-send-email-gjasny@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-01-2012 11:42, Gregor Jasny escreveu:
> Signed-off-by: Gregor Jasny <gjasny@googlemail.com>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  utils/keytable/keytable.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
> index 93609d2..f03de26 100644
> --- a/utils/keytable/keytable.c
> +++ b/utils/keytable/keytable.c
> @@ -226,7 +226,7 @@ static error_t parse_keyfile(char *fname, char **table)
>  						else if (!strcasecmp(p,"sony"))
>  							ch_proto |= SONY;
>  						else if (!strcasecmp(p,"sanyo"))
> -							ch_proto |= SONY;
> +							ch_proto |= SANYO;
>  						else if (!strcasecmp(p,"other") || !strcasecmp(p,"unknown"))
>  							ch_proto |= OTHER;
>  						else {

