Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50104 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2FPEDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 00:03:18 -0400
Received: by weyu7 with SMTP id u7so2466280wey.19
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 21:03:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHPEttk51exv+tQqyBCvTCL5r2APuCPa8E_feyNyzR0PV1yu-Q@mail.gmail.com>
References: <CAHPEttk51exv+tQqyBCvTCL5r2APuCPa8E_feyNyzR0PV1yu-Q@mail.gmail.com>
Date: Sat, 16 Jun 2012 12:03:17 +0800
Message-ID: <CAHPEttkh+teSb9OreafP3PkDubrg+YG9zTaDCijH2yqVUQz_vA@mail.gmail.com>
Subject: dmb-th problem
From: Choi Wing Chan <chanchoiwing@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i have two cards both of them are for dmb-th (mainly used in china and
hong kong). however, these two cards stop working after upgraded the
kernel to 3.3. sadly the drivers were writen by a person David Wong
who has been passed away. i traced the code and found a function
set_delivery_system which assign a value SYS_UNDEFINED in the
frontend's delivery_system.

i am not quite understand the logic below which is a segment of code
inside the function set_delivery_system
fe->ops.delsys[ncapes] = 13 (SYS_DMBTH)
and desired_system = 3 (SYS_DVBT)

               ncaps = 0;
               while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
                       if (fe->ops.delsys[ncaps] == desired_system) {
                               delsys = desired_system;
                               break;
                       }
                       ncaps++;
               }

               // still not find anything
               if (delsys == SYS_UNDEFINED) {
                       dprintk("%s() Couldn't find a delivery system
that matches %d\n",
                               __func__, desired_system);
               }

after these codes, c->delivery_system is set to be SYS_UNDERFINED and
all function after failed.
