Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:48385 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbbBARPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2015 12:15:06 -0500
Received: by mail-qg0-f54.google.com with SMTP id q108so44662439qgd.13
        for <linux-media@vger.kernel.org>; Sun, 01 Feb 2015 09:15:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC8wCFC958=UOGzU2LZ9n_4xVqZOG0V4UJwN2aiiJrSTif_MeQ@mail.gmail.com>
References: <CAC8wCFC958=UOGzU2LZ9n_4xVqZOG0V4UJwN2aiiJrSTif_MeQ@mail.gmail.com>
Date: Sun, 1 Feb 2015 18:15:05 +0100
Message-ID: <CA+O4pCLTnbksB9Tcr87O1JC_6h36uPYT8sjE4SB9dR=7WJ=svA@mail.gmail.com>
Subject: Re: [tvtime] ignores WSS signals
From: Markus Rechberger <mrechberger@gmail.com>
To: Buda Servantes <budaservantes@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It probably won't help you but with Sundtek devices you can register a
WSS callback at the driver which automatically triggers tvtime-command
in the background for adjusting the 4:3 / 16:9

On Sun, Feb 1, 2015 at 5:22 PM, Buda Servantes <budaservantes@gmail.com> wrote:
> I would like to see the following in TVTime:
> Detection of WSS (Letterbox)
> Stretch 4:3 content in 16:9 format automatically based on WSS signal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
