Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33717 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbbLAG2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2015 01:28:22 -0500
Received: by obbww6 with SMTP id ww6so147606883obb.0
        for <linux-media@vger.kernel.org>; Mon, 30 Nov 2015 22:28:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <565CFEB8.3020500@parctech.co.in>
References: <565CFEB8.3020500@parctech.co.in>
Date: Tue, 1 Dec 2015 07:28:21 +0100
Message-ID: <CAJbz7-0+vKsTn6pJnhH=WX+VW6WxEtAgeZepEpqnauVDW=Tj7w@mail.gmail.com>
Subject: Re: how to write TS parsor
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
To: nagaraja_k@parctech.co.in
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I am new to this domain, could any one here please guide me how do I   read
> and pass a particular channel
> from dvbc to a UDP , I am using  MxL214 and 3.10.65 kernel , any help is
> greatly appreciated.

Simplest solution has name "dvblast" - it's free, open-source and robust :)

/Honza
