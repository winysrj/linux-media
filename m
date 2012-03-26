Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55551 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2CZUAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 16:00:14 -0400
Received: by obbeh20 with SMTP id eh20so5539645obb.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 13:00:13 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Mar 2012 22:00:13 +0200
Message-ID: <CAGa-wNP2S32UkFGywyx08BPoOU-WOCbv8mfWxgMj93CwTryQiA@mail.gmail.com>
Subject: Re: dvb-c usb device for linux
From: Claus Olesen <ceolesen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a remark for anyone else interested with a hybrid device that
there now is a specific utility dvb-fe-tool as I discovered to be part
of the next release of the v4l-utils package to set the delivery
system type fx dvb-c or dvb-t. I'm having it called from
/etc/rc.d/rc.local to have the type set on bootup (overwriting the
default set by a driver/module?) until perhaps someday kaffeine can do
it based on a configuration option.
