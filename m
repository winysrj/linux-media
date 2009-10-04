Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:37753 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZJDR6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 13:58:37 -0400
Received: by qyk3 with SMTP id 3so1981533qyk.4
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2009 10:57:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC88895.2040601@tremplin-utc.net>
References: <4AC88895.2040601@tremplin-utc.net>
Date: Sun, 4 Oct 2009 13:57:24 -0400
Message-ID: <303a8ee30910041057p64bf67e6g6a2896a85f50ceed@mail.gmail.com>
Subject: Re: [PATCH] sms1xxx: load smsdvb also for the hauppauge tiger cards
From: Michael Krufky <mkrufky@kernellabs.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Uri Shkolnik <uris@siano-ms.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 4, 2009 at 7:35 AM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> Hello,
>
> Here is a patch to get my DVB-T receiver directly being recognized useful.
> It's against Linus' 2.6.32-rc1.
>
> Eric
>
> ==
>
> I've got a hauppauge tiger minicard (2040:2011), and without smsdvb loaded,
> it's completely useless (to watch TV). So let's add both the minicard and
> the
> minicard r2 to the list of cards which should trigger the load of smsdvb.
>
> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>


Acked-by Michael Krufky <mkrufky@kernellabs.com>

Mauro, please merge this.


> ---
>  drivers/media/dvb/siano/sms-cards.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/dvb/siano/sms-cards.c
> b/drivers/media/dvb/siano/sms-cards.c
> index 0420e28..e216389 100644
> --- a/drivers/media/dvb/siano/sms-cards.c
> +++ b/drivers/media/dvb/siano/sms-cards.c
> @@ -294,6 +294,8 @@ int sms_board_load_modules(int id)
>        case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
>        case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
>        case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> +       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
>                request_module("smsdvb");
>                break;
>        default:
>
