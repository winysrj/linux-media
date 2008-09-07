Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KcQIr-0007AR-0E
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 21:52:10 +0200
Received: by wx-out-0506.google.com with SMTP id t16so34754wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 07 Sep 2008 12:52:04 -0700 (PDT)
Message-ID: <d9def9db0809071252x708f1b1ch6c23cb3d2b5796e9@mail.gmail.com>
Date: Sun, 7 Sep 2008 21:52:04 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Simon Kenyon" <simon@koala.ie>
In-Reply-To: <48C42851.8070005@koala.ie>
MIME-Version: 1.0
Content-Disposition: inline
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com> <20080904204709.GA32329@linuxtv.org>
	<d9def9db0809041632q54b734bcm124018d8e0f72635@mail.gmail.com>
	<48C1380F.7050705@linuxtv.org> <48C42851.8070005@koala.ie>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Sun, Sep 7, 2008 at 9:15 PM, Simon Kenyon <simon@koala.ie> wrote:
> Steven Toth wrote:
>> A big difference between can and will, the em28xx fiasco tells us this.
>>
> just wondering if your tree will go any way towards resolving that
> little problem?

I don't see any fiasco nor problem here, it's more comfortable to have
the em28xx in an extra
tree and do ongoing development with it. People who followed the
development  during the last
few years know that newer things got added and newer chips are
supported by it, it will continue
to evolve anyway.

The driverwork is currently around 30% of it, patching applications
and providing full support from
the driver till the endapplications is what everything's focussing on
mcentral.de not just driver only
development.

We do dedicated application support for several customers too (analog
tv, radio, dvb integration in their
business applications).
There are many new products coming up, adding support for them is on
the roadmap.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
