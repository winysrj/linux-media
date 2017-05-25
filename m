Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33776 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036529AbdEYT7q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 15:59:46 -0400
Received: by mail-oi0-f44.google.com with SMTP id w10so294206049oif.0
        for <linux-media@vger.kernel.org>; Thu, 25 May 2017 12:59:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201705260103.5T6Pqsjx%fengguang.wu@intel.com>
References: <013d515d13693a66ecc927b985c2b0db720c257f.1495190226.git.mchehab@s-opensource.com>
 <201705260103.5T6Pqsjx%fengguang.wu@intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 25 May 2017 21:59:45 +0200
Message-ID: <CAK8P3a3TEe+S97cw-LLLE2Fc9Aw-ta8pdaRHM0XW9naMEn=KGw@mail.gmail.com>
Subject: Re: [PATCH] [media] atomisp: disable several warnings when W=1
To: kbuild test robot <lkp@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        kbuild-all@01.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 25, 2017 at 7:03 PM, kbuild test robot <lkp@intel.com> wrote:

>>> cc1: warning: unrecognized command line option "-Wno-suggest-attribute=format"
>>> cc1: warning: unrecognized command line option "-Wno-unused-but-set-variable"
>>> cc1: warning: unrecognized command line option "-Wno-unused-const-variable"

Ah right, these need to use "$(cc-disable-warning)" in the Makefile. I
also missed
this when I looked at the original patch/

        Arnd
