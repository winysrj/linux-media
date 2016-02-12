Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35063 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbcBLS2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 13:28:37 -0500
Received: by mail-vk0-f44.google.com with SMTP id e6so66922132vkh.2
        for <linux-media@vger.kernel.org>; Fri, 12 Feb 2016 10:28:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56BAE988.1050106@xs4all.nl>
References: <56BAE988.1050106@xs4all.nl>
Date: Fri, 12 Feb 2016 19:28:35 +0100
Message-ID: <CALtnZsCVgy2HJyTXFdij=oEERn4==Sftsg1EP4tRYf5a52cizA@mail.gmail.com>
Subject: Re: [PATCH] timblogiw: move to staging in preparation for removal
From: =?UTF-8?Q?Richard_R=C3=B6jfors?= <richard@puffinpack.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-02-10 8:40 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> The Timberdale FPGA video driver has not seen any real development
> since 2011 (and very little before that).
>
> One of the problems with the timblogiw driver is that it uses videobuf
> instead of the newer vb2 framework. The long term goal is to either
> convert or remove any driver still using videobuf. Since none of the
> core v4l developers has the hardware, we cannot convert it ourselves.
>
> As far as I can tell it was only used in an Intel demo board in 2009
> using Meego:
>
> http://www.chinait.com/intelcontent/intelprc/admin/PDFFile/20106411545.pdf
>
> which has since been superseded.
>
> Moving this driver to staging is the first step towards removal. After 2 or
> 3 kernel cycles it will be removed altogether unless someone steps up to
> clean up this driver.

Acked-by: Richard Röjfors <richard@puffinpack.se>
