Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41051 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244AbbFJMwU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 08:52:20 -0400
Date: Wed, 10 Jun 2015 09:52:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andy Furniss <adf.lists@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvbv5-tzap with pctv 290e/292e needs EAGAIN for pat/pmt to work
 when recording.
Message-ID: <20150610095215.79e5e77e@recife.lan>
In-Reply-To: <556E2D5B.5080201@gmail.com>
References: <556E2D5B.5080201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Jun 2015 23:25:31 +0100
Andy Furniss <adf.lists@gmail.com> escreveu:

> Running kernel 3.18.14 with git master v4l-utils and a pctv290e + a 292e.
> 
> If I try to record with dvbv5-zap and include the "p" option to get
> pat/pmt I get -
> 
> read_sections: read error: Resource temporarily unavailable
> couldn't find pmt-pid for sid 10bf
> 
> Doing this this fixes it for me (obviously not meant to be a a proper 
> patch).

You forgot to send your Signed-off-by on this patch ;)

Anyway, there are other places where EAGAIN may happen. So, the best
is to fix it globally.

Just applied a fix for it:
	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=c7c9af17163f282a147ea76f1a3c0e9a0a86e7fa

It will retry up to 10 times. This should very likely be enough if the
driver doesn't have any bug.

Please let me know if this fixes the issue.

Regards,
Mauro

> 
> diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
> index 30d4eda..b520948 100644
> --- a/lib/libdvbv5/dvb-demux.c
> +++ b/lib/libdvbv5/dvb-demux.c
> @@ -151,8 +151,10 @@ int dvb_get_pmt_pid(int patfd, int sid)
>                  if (((count = read(patfd, buf, sizeof(buft))) < 0) && 
> errno == EOVERFLOW)
>                  count = read(patfd, buf, sizeof(buft));
>                  if (count < 0) {
> -               perror("read_sections: read error");
> -               return -1;
> +                       if (errno == EAGAIN) /*ADF*/
> +                               continue;
> +                       perror("read_sections: read error");
> +                       return -1;
>                  }
> 
>                  section_length = ((buf[1] & 0x0f) << 8) | buf[2];
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
