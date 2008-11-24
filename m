Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp123.rog.mail.re2.yahoo.com ([206.190.53.28])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1L4TPR-0008Nm-Jh
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 05:50:55 +0100
Message-ID: <492A328A.7090502@rogers.com>
Date: Sun, 23 Nov 2008 23:50:18 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Bob Cunningham <FlyMyPG@gmail.com>
References: <49287DCC.9040004@gmail.com>
	<37219a840811231121u1350bf61n57109a1600f6dd92@mail.gmail.com>
	<4929B192.8050707@rogers.com> <4929FE90.2050008@gmail.com>
In-Reply-To: <4929FE90.2050008@gmail.com>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] AnyTV AUTV002 USB ATSC/QAM Tuner Stick
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

Bob Cunningham wrote:
> There are 3 chips, from the USB to the cable connector they are:
> AU0828A
> AU8522AA
> MT2131F
>
> The silk screen text on the PC board reads "AUTV002_Ver1.0c"
>
> Pictures soon!

Okay, thanks

> Hi yet again,
> > 
> > I checked the source, and it seems the patch I found (http://marc.info/?l=linux-dvb&m=122416362902362&w=2) had indeed not yet been committed to the tree.  I applied it to my updated source and reinstalled v4l.  The following devices now appear:
> > 
> > /dev/audio1
> > /dev/dsp1
> > /dev/dvb/adapter0
> > /dev/mixer1
> > /dev/ptmx
> > 
> > I have no idea if they are functional!  I tried running xine, but I am unfamiliar with it, so I don't know if there is a problem in the driver, or if it is a PEBKAC.
> > 
> > What is the preferred testing strategy?
> > 
> > 
> > Thanks,
> > 
> > -BobC
>   
>
>
> As I stumbled through the maze, I was suddenly struck by a clue-by-4, and the following occurred:
>
>     $ dvbscan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB 
>     Unable to query frontend status
>
> I take it this is not a good thing.
>
> ...
>
> Tried this next:
>     $ scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB 
>     scanning /usr/share/dvb-apps/atsc/us-ATSC-center-frequencies-8VSB
>     using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>     >>> tune to: 57028615:8VSB
>     WARNING: >>> tuning failed!!!
>     >>> tune to: 57028615:8VSB (tuning failed)
>     ... snip over 40 other attempts ...
>     >>> tune to: 803028615:8VSB
>     WARNING: >>> tuning failed!!!
>     >>> tune to: 803028615:8VSB (tuning failed)
>     WARNING: >>> tuning failed!!!
>     ERROR: initial tuning failed
>     dumping lists (0 services)
>     Done.
>
> Still not success, but at least the devices were found and are accessible.
>   

What tuner is being listed in your dmesg output ?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
