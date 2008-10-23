Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oroitburd@gmail.com>) id 1Kt2EI-0003Rw-Iv
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 17:36:07 +0200
Received: by gv-out-0910.google.com with SMTP id n29so20890gve.16
	for <linux-dvb@linuxtv.org>; Thu, 23 Oct 2008 08:36:02 -0700 (PDT)
Message-ID: <b42fca4d0810230836r76947a97qb6356c86e7e9917c@mail.gmail.com>
Date: Thu, 23 Oct 2008 17:36:02 +0200
From: "oleg roitburd" <oroitburd@gmail.com>
To: "Igor M. Liplianin" <liplianin@tut.by>
In-Reply-To: <200810230300.43637.liplianin@tut.by>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0810220607x588735f2v780104a5cafc3b8a@mail.gmail.com>
	<48FF5C43.9090309@linuxtv.org> <200810230300.43637.liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] stb0899 drivers
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/10/23 Igor M. Liplianin <liplianin@tut.by>:
> Hi Steven and Mauro
>
> As I understand, now we all waiting (again!) for Manu Abraham to commit?
> Truly his code are huge and needs long time to clean up, but I made
> http://mercurial.intuxication.org/hg/s2-liplianin
> in order to help to convert it.
> Right now I state the code is stable and works absolutely of no difference with multiproto
> version.
> I mean it locks all channels, which multiproto version locks, but without any modifications to
> current DVB API.
> What can I do now?
>
> Igor

Thx a lot. It works fine. I'm voting for merge your tree to v4l-dvb.


Regards
Oleg Roitburd

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
