Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mognix.dark-green.com ([88.116.226.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gimli@dark-green.com>) id 1LJtoG-0007Rk-Eu
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 19:04:18 +0100
Message-ID: <40677.62.178.208.71.1231178656.squirrel@webmail.dark-green.com>
In-Reply-To: <20090105173606.271160@gmx.net>
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>
	<c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
	<20081206170753.69410@gmx.net> <20081209153451.75130@gmx.net>
	<20081215143047.45940@gmx.net> <20090104192435.72460@gmx.net>
	<59327.62.178.208.71.1231173948.squirrel@webmail.dark-green.com>
	<20090105173606.271160@gmx.net>
Date: Mon, 5 Jan 2009 19:04:16 +0100 (CET)
From: "gimli" <gimli@dark-green.com>
To: "Hans Werner" <HWerner4@gmx.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Mantis Bug (was Technisat HD2 cannot
 szap/scan)
Reply-To: gimli@dark-green.com
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

Hi,

with both patches applied i get the following error :

[   30.531297] stb6100_set_bandwidth: Bandwidth=3D51610000
[   30.539648] stb6100_get_bandwidth: Bandwidth=3D52000000
[   30.566553] stb6100_get_bandwidth: Bandwidth=3D52000000
[   30.658597] stb6100_set_frequency: Frequency=3D1945000
[   30.667055] stb6100_get_frequency: Frequency=3D1945001
[   30.680914] stb6100_get_bandwidth: Bandwidth=3D52000000
[   58.768515] mantis_ack_wait (0): Slave RACK Fail !
[   58.796058] stb6100_set_bandwidth: Bandwidth=3D47125000
[   58.804958] stb6100_get_bandwidth: Bandwidth=3D48000000
[   58.902104] stb6100_set_frequency: Frequency=3D1314000
[   58.910452] stb6100_get_frequency: Frequency=3D1314008
[   66.368516] mantis_ack_wait (0): Slave RACK Fail !
[   73.492514] mantis_ack_wait (0): Slave RACK Fail !
[   73.492869] _stb0899_read_s2reg ERR(1), Device=3D[0xf3fc], Base
address=3D[0x00000400], Offset=3D[0xf340], Status=3D-121
[   73.543296] stb6100_set_bandwidth: Bandwidth=3D39700000
[   73.551801] stb6100_get_bandwidth: Bandwidth=3D40000000
[   73.654595] stb6100_set_frequency: Frequency=3D1612000
[   73.662983] stb6100_get_frequency: Frequency=3D1611984
[   76.071648] stb6100_set_bandwidth: Bandwidth=3D47125000
[   76.080540] stb6100_get_bandwidth: Bandwidth=3D48000000
[   76.186597] stb6100_set_frequency: Frequency=3D1314000
[   76.194986] stb6100_get_frequency: Frequency=3D1314008
[   99.268030] mantis_ack_wait (0): Slave RACK Fail !
[   99.268385] _stb0899_read_s2reg ERR(2), Device=3D[0xf3fc], Base
address=3D[0x00000400], Offset=3D[0xf340], Status=3D-121
[   99.323138] stb6100_set_bandwidth: Bandwidth=3D51610000
[   99.332078] stb6100_get_bandwidth: Bandwidth=3D52000000
[   99.360190] stb6100_get_bandwidth: Bandwidth=3D52000000
[   99.446602] stb6100_set_frequency: Frequency=3D2092000
[   99.454959] stb6100_get_frequency: Frequency=3D2092025

This occurs when tuning from an SD Channel to an S2 Transponder. In
my case to Anixe HD. After tuning to the S2 transponder no channel work.

mfg

Edgar (gimli) Hucek

>> Hi,
>>
>> with your patch i run into following problem on a Terratec Cinergy S2
>> PCI
>> HD :
>>
>> [  143.818103] stb6100_set_frequency: Frequency=3D1588000
>> [  143.826681] stb6100_get_frequency: Frequency=3D1587990
>> [  143.840867] stb6100_get_bandwidth: Bandwidth=3D10000000
>> [  150.568018] mantis_ack_wait (0): Slave RACK Fail !
>> [  150.568372] stb6100_set_bandwidth: Invalid parameter
>> [  156.596525] mantis_ack_wait (0): Slave RACK Fail !
>> [  156.596880] stb6100_get_bandwidth: Invalid parameter
>> [  162.784014] mantis_ack_wait (0): Slave RACK Fail !
>> [  162.784368] stb6100_get_bandwidth: Invalid parameter
>> [  168.848014] mantis_ack_wait (0): Slave RACK Fail !
>> [  168.848368] stb6100_set_frequency: Invalid parameter
>> [  174.896016] mantis_ack_wait (0): Slave RACK Fail !
>> [  174.896371] stb6100_get_frequency: Invalid parameter
>>
>> cu
>>
>> Edgar (gimli) Hucek
>
> Hi Edgar,
>
> I don't believe the Slave RACK problem is caused by my LNBP21 patch -- I
> saw it before
> and I posted a fix for it already at
> http://linuxtv.org/pipermail/linux-dvb/2008-December/030829.html
>
> Here it is again:
>
> diff -r 28324bc3d694 linux/drivers/media/dvb/mantis/mantis_i2c.c
> --- a/linux/drivers/media/dvb/mantis/mantis_i2c.c
> +++ b/linux/drivers/media/dvb/mantis/mantis_i2c.c
> @@ -42,7 +42,7 @@ static int mantis_ack_wait(struct mantis
>                 dprintk(verbose, MANTIS_DEBUG, 1, "Master !I2CDONE");
>                 rc =3D -EREMOTEIO;
>         }
> -       while (!(mantis->mantis_int_stat & MANTIS_INT_I2CRACK)) {
> +       while (!(mantis->mantis_int_stat & MANTIS_INT_I2CDONE)) {
>                 dprintk(verbose, MANTIS_DEBUG, 1, "Waiting for Slave
> RACK");
>                 mantis->mantis_int_stat =3D mmread(MANTIS_INT_STAT);
>                 msleep(5);
>
>
> Regards,
> Hans
>
>
>> >> With the Azurewave AD-SP400 (Twinhan VP-1041 / Technisat HD2 /
>> >> ?poss. Terratec Cinergy S2 PCI HD)
>> >> there seems to be a driver bug when tuning some channels immediately
>> >> after boot or after resuming from sleep (which is entered after 1
>> minute
>> >> idle).
>> >> So the initialisation seems to be unsuitable for tuning some
>> channels.
>> >>
>> >> But... if another channel is tuned successfully first then the bad
>> >> channels *CAN* be tuned
>> >> (if you are quick and do it before it sleeps again).
>> >>
>> >> It looks like the problem channels are all horizontal but perhaps
>> other
>> >> parameters are
>> >> relevant too/instead.
>> >>
>> >> Can anyone help?
>> >> Instructions for reproducing the problem on Astra 19.2E or Hotbird
>> 13.0E
>> >> are below.
>> >>
>> >> I don't know whether the problem is in the mantis, stb0899, stb6100
>> or
>> >> lnbp21 code.
>> >
>> > Problem solved with the patch below.
>> >
>> > I found that both problems tuning channels (#1 immediately after boot
>> and
>> > #2 after sleep) are
>> > caused by the lnbp21 voltage OFF setting. To fix #1: the LNB voltage
>> needs
>> > to be turned on when
>> > the lnbp21 is attached, and to fix #2: turning the voltage off on
>> sleep
>> > needs to be disabled.
>> >
>> > To keep the voltage on, we need to make sure that register bit
>> LNBP21_EN
>> > is always set.
>> >
>> > I note that as well as controlling the voltage regulator blocks this
>> > register bit also controls
>> > a loopthrough switch -- clearing the bit takes the lnbp21 out of the
>> LNB
>> > line, which could be
>> > used to allow other circuitry to do LNB power and control. I don't
>> have
>> > any info on how the
>> > card is actually wired. It seems best to keep the EN bit always set,
>> > because I know clearing
>> > it causes trouble.
>> >
>> > It turns out there is already a mechanism for specifying register bits
>> to
>> > be overridden in
>> > the lnbp21 attach call (already used for another card) and we just
>> need
>> to
>> > apply the following
>> > one-line patch to the VP-1041 attach.
>> >
>> > This is against the repository at
>> > http://mercurial.intuxication.org/hg/s2-liplianin.
>> >
>> > Signed-off-by: Hans Werner <hwerner4@gmx.de>
>> >
>> > diff -r 28324bc3d694 linux/drivers/media/dvb/mantis/mantis_dvb.c
>> > --- a/linux/drivers/media/dvb/mantis/mantis_dvb.c
>> > +++ b/linux/drivers/media/dvb/mantis/mantis_dvb.c
>> > @@ -239,7 +239,7 @@ int __devinit mantis_frontend_init(struc
>> >                         vp1041_config.demod_address);
>> >
>> >                         if (stb6100_attach(mantis->fe,
>> > &vp1041_stb6100_config, &mantis->adapter)) {
>> > -                               if (!lnbp21_attach(mantis->fe,
>> > &mantis->adapter, 0, 0)) {
>> > +                               if (!lnbp21_attach(mantis->fe,
>> > &mantis->adapter, LNBP21_EN, 0)) {
>> >                                         printk("%s: No LNBP21
>> found!\n",
>> > __FUNCTION__);
>> >                                         mantis->fe =3D NULL;
>> >                                 }
>> >
>> >
>> >
>> > Regards,
>> > Hans
>
> --
> Release early, release often.
>
> Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen:
> http://www.gmx.net/de/go/multimessenger
>
>
>



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
