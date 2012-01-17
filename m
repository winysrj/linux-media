Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab2AQIUL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 03:20:11 -0500
Message-ID: <4F152F84.90402@redhat.com>
Date: Tue, 17 Jan 2012 09:21:24 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
References: <4F134701.9000105@googlemail.com>
In-Reply-To: <4F134701.9000105@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/15/2012 10:37 PM, Gregor Jasny wrote:
> Hello,
>
> I'm Gregor the Debian (and thus Ubuntu) Maintainer of v4l-utils. I took
> the challenge to convert the Makefile based build system into an
> autotools one. This weekend I polished the last bits and submitted my
> changes.
>
> If you build v4l-utils from source, please clean your tree via "git
> clean" after the pull. Then make sure you have autotools, libtool and
> pkg-config installed. Bootstrap the autotools environment by calling
> "autoreconf -vfi". The rest is the usual configure&&  make&&  make install.

Good work! And many thanks for working on this.

Regards,

Hans
