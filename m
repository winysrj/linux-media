Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46770 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0ANJ5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 04:57:06 -0500
Received: by fxm25 with SMTP id 25so293424fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 01:57:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f74f98341001140147u7f5f1e91ga6ae3a06e23360@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <bc1576c0e8d05b415e03292a4640021e.squirrel@webmail.xs4all.nl>
	 <f74f98341001140147u7f5f1e91ga6ae3a06e23360@mail.gmail.com>
Date: Thu, 14 Jan 2010 13:57:02 +0400
Message-ID: <1a297b361001140157g49f7738agfefe47b7c84c5a0b@mail.gmail.com>
Subject: Re: About driver architecture
From: Manu Abraham <abraham.manu@gmail.com>
To: Michael Qiu <fallwind@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 1:47 PM, Michael Qiu <fallwind@gmail.com> wrote:
> Thanks for you reply.
>
> The SOC is still under development stage, it's not a product yet. And
> a small mistake I've made, the tuner will not integrated into the SOC.
> The demod might be.


You mean a similar scheme as in the STi7111.
http://www.st.com/stonline/products/literature/bd/14287.pdf

It is a standard approach used in DVB STB's. Recently the decoders are
being builtin with the DVB demodulators to have more control as well
as to reduce the complexity of the hardware and software and
eventually the cost.

Regards,
Manu
