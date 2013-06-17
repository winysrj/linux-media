Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53065 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3FQO74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 10:59:56 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so1268277bkc.16
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 07:59:55 -0700 (PDT)
Message-ID: <51BF2469.9010608@googlemail.com>
Date: Mon, 17 Jun 2013 16:59:53 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Doing a v4l-utils-1.0.0 release
References: <51BAC2F6.40708@redhat.com>
In-Reply-To: <51BAC2F6.40708@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 6/14/13 9:15 AM, Hans de Goede wrote:
> So how about taking current master and releasing that as a 1.0.0 release ?

I'm fine with preparing a 1.0.0 release.

But I'm under the impression that the libdvbv5 interface is not polished 
enough to build a shared library from it. So I'd like to change the 
autoconf default to false and skip installing the static and shared library.

Any objections?

Thanks,
Gregor
