Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58743 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2JHG0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 02:26:20 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1814689bkc.19
        for <linux-media@vger.kernel.org>; Sun, 07 Oct 2012 23:26:18 -0700 (PDT)
Message-ID: <50727208.8020902@googlemail.com>
Date: Mon, 08 Oct 2012 08:26:16 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Khem Raj <raj.khem@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [v4l-utils] Use RCC variable to call rcc compiler
References: <1349635312-3045-1-git-send-email-raj.khem@gmail.com>
In-Reply-To: <1349635312-3045-1-git-send-email-raj.khem@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Khem,

On 10/7/12 8:41 PM, Khem Raj wrote:
> In cross compile environment rcc native version
> may be staged in a different directory or even
> called rcc4 or somesuch. Lets provide a facility
> to specify it in environment

I'll take care of this patch.

> diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
> index 02d0bcb..86d0285 100644
> --- a/utils/qv4l2/Makefile.am
> +++ b/utils/qv4l2/Makefile.am
> @@ -29,7 +29,7 @@ moc_capture-win.cpp: $(srcdir)/capture-win.h
>  
>  # Call the Qt resource compiler
>  qrc_qv4l2.cpp: $(srcdir)/qv4l2.qrc
> -	rcc -name qv4l2 -o $@ $(srcdir)/qv4l2.qrc
> +	$(RCC) -name qv4l2 -o $@ $(srcdir)/qv4l2.qrc
>  
>  install-data-local:
>  	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2.desktop"   "$(DESTDIR)$(datadir)/applications/qv4l2.desktop"
> 

Where does RCC gets populated? The configure.ac parts seems to be missing.

Thanks,
Gregor
