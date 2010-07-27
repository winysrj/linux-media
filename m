Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55900 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0G0K5S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 06:57:18 -0400
Received: by ewy23 with SMTP id 23so1185029ewy.19
        for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 03:57:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinU8gO1gx+3wD4hqYp7O2U2RC2UQ597Jag=gMPw@mail.gmail.com>
References: <AANLkTinU8gO1gx+3wD4hqYp7O2U2RC2UQ597Jag=gMPw@mail.gmail.com>
Date: Tue, 27 Jul 2010 13:56:46 +0300
Message-ID: <AANLkTi=C_BLRBpp94VNb18cGkLjaFbfAeq_ZnCUUVn1L@mail.gmail.com>
Subject: Re: [PATCH] Fix possible memory leak in dvbca.c
From: Tomer Barletz <barletz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/7/25 Tomer Barletz <barletz@gmail.com>:
> Allocated memory will never get free when read fails.
> See attached patch.
>
> Tomer
>

Does anybody knows who's dvb-apps maintainer?
