Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KjgZN-0002SA-62
	for linux-dvb@linuxtv.org; Sat, 27 Sep 2008 22:39:13 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1010977fga.25
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 13:39:10 -0700 (PDT)
Message-ID: <d9def9db0809271339w70e64903o6a2026840cce5f6f@mail.gmail.com>
Date: Sat, 27 Sep 2008 22:39:09 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "David BERCOT" <linux-dvb@bercot.org>
In-Reply-To: <20080927221314.1313010c@david.huperie>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080927201547.2fbde736@david.huperie>
	<d9def9db0809271230p561c022aoa2a32c8806688f68@mail.gmail.com>
	<20080927221314.1313010c@david.huperie>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How installing em28xx ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, Sep 27, 2008 at 10:13 PM, David BERCOT <linux-dvb@bercot.org> wrote:
> Hi,
>
> Le Sat, 27 Sep 2008 21:30:38 +0200,
> "Markus Rechberger" <mrechberger@gmail.com> a =E9crit :
>> Hi,
>>
>> On Sat, Sep 27, 2008 at 8:15 PM, David BERCOT <linux-dvb@bercot.org>
>> wrote:
>> > Hi,
>> >
>> > I used em28xx for the past, but now, it seems to be more
>> > complicated... In http://mcentral.de/hg I found em28xx-new (but I
>> > have many errors : [...]
>> > 'dvb_net_release' /opt/em28xx-new/em2880-dvb.c:976: erreur: implicit
>> > declaration of function
>> > 'dvb_unregister_frontend' /opt/em28xx-new/em2880-dvb.c:977: erreur:
>> > implicit declaration of function
>> > 'dvb_frontend_detach' /opt/em28xx-new/em2880-dvb.c:981: erreur:
>> > implicit declaration of function
>> > 'dvb_dmx_release' /opt/em28xx-new/em2880-dvb.c:983: erreur: implicit
>> > declaration of function 'dvb_unregister_adapter'
>> > [...]) and the "old" v4l-dvb-kernel & v4l-dvb-experimental doesn't
>> > work any more since 2.6.26 kernel.
>> > I should use multiproto, but it seems heavy, no ?
>> >
>> > Do you have any suggestion ?
>>
>> do you have a custom kernel? or a default distribution - and which
>> one?
>
> No, it is a classical kernel : 2.6.26-1-686 on Debian Sid.
> Should I put all the errors ?
>

>> > 'dvb_unregister_frontend' /opt/em28xx-new/em2880-dvb.c:977: erreur:
>> > implicit declaration of function

this means it cannot find some headers, you need to install the full
kernel sources for your installed
kernel before compiling the driver.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
