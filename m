Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zeno.zoli@gmail.com>) id 1K5I9w-0007SE-4k
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 12:30:02 +0200
Received: by mu-out-0910.google.com with SMTP id w8so1171656mue.1
	for <linux-dvb@linuxtv.org>; Sun, 08 Jun 2008 03:29:56 -0700 (PDT)
Message-ID: <45e226e50806080329t3e5962b1w8f6701b72119f36f@mail.gmail.com>
Date: Sun, 8 Jun 2008 12:29:56 +0200
From: "Zeno Zoli" <zeno.zoli@gmail.com>
To: "Faruk A" <fa@elwak.com>
In-Reply-To: <854d46170806071111s65b96325mfc8beaa6171259dd@mail.gmail.com>
MIME-Version: 1.0
References: <45e226e50806060327s7e3ecf86wb9141ee394e854d1@mail.gmail.com>
	<E1K4ZQk-000ARd-00.goga777-bk-ru@f145.mail.ru>
	<45e226e50806060353o32b215afwc3017e3ab8a2dd10@mail.gmail.com>
	<854d46170806060550u5c238e26ia003c713ed68095e@mail.gmail.com>
	<45e226e50806071017y4e09413dl23c119da0910fae2@mail.gmail.com>
	<854d46170806071111s65b96325mfc8beaa6171259dd@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy S2 PCI HD ioctl DVBFE_GET_INFO
	failed:Operation not supported
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0078225340=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0078225340==
Content-Type: multipart/alternative;
	boundary="----=_Part_1690_23464789.1212920996746"

------=_Part_1690_23464789.1212920996746
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks. I got the scan working. It failed on most frequencies though.

----------------------------------> Using 'STB0899 Multistandard' DVB-S

Shouldn't that be:
----------------------------------> Using 'STB0899 Multistandard' DVB-S2  ?

Besides that. Do you know where the patched szap2 can be found, or is there
an alternative?
Tried Kaffeine, but still without success. Guess I need a kaffeine patch
too.


On Sat, Jun 7, 2008 at 8:11 PM, Faruk A <fa@elwak.com> wrote:

> Hi Zeno!
>
> If i remember correctly i think i got Hunk failed too i had to paste
> it manually.
> here is my copy already been patched and compiled. If the binary scan
> doesn't work run "make clean" and then "make"
> http://www.zshare.net/download/1322006118c9c70a/
>
> Faruk
>
>
> On Sat, Jun 7, 2008 at 7:17 PM, Zeno Zoli <zeno.zoli@gmail.com> wrote:
> > Tried, and got
> >
> > Hunk #1 FAILED at 1674.
> > Hunk #2 FAILED at 1693.
> > Hunk #3 FAILED at 1704.
> >
> >
> >
> > On Fri, Jun 6, 2008 at 2:50 PM, Faruk A <fa@elwak.com> wrote:
> >>
> >> Hi Zeno!
> >>
> >> Apply this patch.
> >>
> >> diff -Naur 1/scan.c 2/scan.c
> >> --- 1/scan.c    2008-04-03 02:00:19.000000000 +0200
> >> +++ 2/scan.c    2008-04-03 12:29:32.000000000 +0200
> >> @@ -1674,15 +1674,18 @@
> >>        }
> >>
> >>         struct dvbfe_info fe_info1;
> >> +       enum dvbfe_delsys delivery;
> >>
> >>         // a temporary hack, need to clean
> >>         memset(&fe_info1, 0, sizeof (struct dvbfe_info));
> >>
> >>         if(t->modulation_system == 0)
> >> -            fe_info1.delivery = DVBFE_DELSYS_DVBS;
> >> +            delivery = DVBFE_DELSYS_DVBS;
> >>         else if(t->modulation_system == 1)
> >> -            fe_info1.delivery = DVBFE_DELSYS_DVBS2;
> >> -
> >> +            delivery = DVBFE_DELSYS_DVBS2;
> >> +
> >> +        ioctl(frontend_fd, DVBFE_SET_DELSYS, &delivery); //switch
> system
> >> +
> >>         int result = ioctl(frontend_fd, DVBFE_GET_INFO, &fe_info1);
> >>         if (result < 0) {
> >>             perror("ioctl DVBFE_GET_INFO failed");
> >> @@ -1690,7 +1693,7 @@
> >>             return -1;
> >>         }
> >>
> >> -        switch (fe_info1.delivery) {
> >> +        switch (delivery) {
> >>             case DVBFE_DELSYS_DVBS:
> >>                 info("----------------------------------> Using '%s'
> >> DVB-S\n", fe_info.name);
> >>                 break;
> >> @@ -1701,7 +1704,7 @@
> >>                 info("----------------------------------> Using '%s'
> >> DVB-S2\n", fe_info.name);
> >>                 break;
> >>             default:
> >> -                info("Unsupported Delivery system (%d)!\n",
> >> fe_info1.delivery);
> >> +                info("Unsupported Delivery system (%d)!\n", delivery);
> >>                 t->last_tuning_failed = 1;
> >>                 return -1;
> >>         }
> >>
> >>
> >>
> >> 2008/6/6 Zeno Zoli <zeno.zoli@gmail.com>:
> >> > I suppose so
> >> >
> >> > wget http://jusst.de/manu/scan.tar.bz2
> >> > from
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI
> >> >
> >> >
> >> >
> >> >
> >> >
> >> > 2008/6/6 Goga777 <goga777@bk.ru>:
> >> >>
> >> >> which scan version do you use ? does it support the multiproto api ?
> >> >>
> >> >>
> >> >>
> >> >>
> >> >> > I'm new to DVB on linux, but have some linux experience. I have
> >> >> > trouble
> >> >> > to
> >> >> > get my new Terratec Cinergy S2 PCI HD to work properly. I have
> >> >> > followed
> >> >> > the
> >> >> > guide here:
> >> >> > http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI
> >> >> >
> >> >> > I get "ioctl DVBFE_GET_INFO failed: Operation not supported"
> >> >> > when I try to ./scan -vv dvb-s/Thor-1.0W ( more info below)
> >> >> >
> >> >> > Could it be related to my choice of Ubuntu 2.6.24-16-server?
> >> >> > Thanks for your help.
> >> >> >
> >> >> > Zeno.
> >> >> >
> >> >> >
> >> >> > uname -a
> >> >> > Linux htpc 2.6.24-16-server #1 SMP i686 GNU/Linux
> >> >> >
> >> >> > /home/htpc/scan# ./scan -vv dvb-s/Thor-1.0W
> >> >> > scanning dvb-s/Thor-1.0W
> >> >> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> >> >> > initial transponder 11247000 V 24500000 24500000
> >> >> > initial transponder 11293000 H 24500000 24500000
> >> >> > initial transponder 11325000 H 24500000 24500000
> >> >> > initial transponder 12054000 H 28000000 28000000
> >> >> > initial transponder 12169000 H 28000000 28000000
> >> >> > initial transponder 12226000 V 28000000 28000000
> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
> >> >> > ERROR: initial tuning failed
> >> >> > dumping lists (0 services)
> >> >> >
> >> >> > lsmod
> >> >> >
> >> >> > lnbp21                  3200  1 mantis
> >> >> > mb86a16                21632  1 mantis
> >> >> > stb6100                 8836  1 mantis
> >> >> > tda10021                7684  1 mantis
> >> >> > tda10023                7300  1 mantis
> >> >> > stb0899                36224  1 mantis
> >> >> > stv0299                11528  1 mantis
> >> >> > dvb_core               89212  2 mantis,stv0299
> >> >> >
> >> >> >
> >> >> > dmesg
> >> >> >
> >> >> >  36.793511] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on
> (02:09.0),
> >> >> > [   36.793513]     Mantis Rev 1 [153b:1179], irq: 20, latency: 64
> >> >> > [   36.793515]     memory: 0xfddff000, mmio: 0xf8a54000
> >> >> > [   36.796981]     MAC Address=[00:08:ca:1c:a8:e9]
> >> >> > [   36.797011] mantis_alloc_buffers (0): DMA=0x37560000
> >> >> > cpu=0xf7560000
> >> >> > size=65536
> >> >> > [   36.797061] mantis_alloc_buffers (0): RISC=0x37501000
> >> >> > cpu=0xf7501000
> >> >> > size=1000
> >> >> > [   36.797107] DVB: registering new adapter (Mantis dvb adapter)
> >> >> > [   37.345712] stb0899_get_dev_id: Device ID=[8], Release=[2]
> >> >> > [   37.358369] stb0899_get_dev_id: Demodulator Core ID=[DMD1],
> >> >> > Version=[1]
> >> >> > [   37.371023] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
> >> >> > [   37.371074] stb0899_attach: Attaching STB0899
> >> >> > [   37.371076] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2
> >> >> > frontend
> >> >> > @0x68
> >> >> > [   37.371135] stb6100_attach: Attaching STB6100
> >> >> > [   37.371491] DVB: registering frontend 0 (STB0899
> Multistandard)...
> >> >> > [   37.371523] mantis_ca_init (0): Registering EN50221 device
> >> >> > [   37.372914] mantis_ca_init (0): Registered EN50221 device
> >> >> > [   37.372973] mantis_hif_init (0): Adapter(0) Initializing Mantis
> >> >> > Host
> >> >> > Interface
> >> >> >
> >> >> > lspci -v
> >> >> > 02:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis
> DTV
> >> >> > PCI
> >> >> > Bridge Controller [Ver 1.0] (rev 01)
> >> >> >         Subsystem: TERRATEC Electronic GmbH Unknown device 1179
> >> >> >         Flags: bus master, medium devsel, latency 64, IRQ 20
> >> >> >         Memory at fddff000 (32-bit, prefetchable) [size=4K]
> >> >>
> >> >> >
> >> >>
> >> >> _______________________________________________
> >> >> linux-dvb mailing list
> >> >> linux-dvb@linuxtv.org
> >> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >> >
> >> >
> >> > _______________________________________________
> >> > linux-dvb mailing list
> >> > linux-dvb@linuxtv.org
> >> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >> >
> >
> >
>

------=_Part_1690_23464789.1212920996746
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks. I got the scan working. It failed on most frequencies though.<br><br>----------------------------------&gt; Using &#39;STB0899 Multistandard&#39; DVB-S<br><br>Shouldn&#39;t that be:<br>----------------------------------&gt; Using &#39;STB0899 Multistandard&#39; DVB-S2&nbsp; ?<br>
<br>Besides that. Do you know where the patched szap2 can be found, or is there an alternative?<br>Tried Kaffeine, but still without success. Guess I need a kaffeine patch too.<br><br><br><div class="gmail_quote">On Sat, Jun 7, 2008 at 8:11 PM, Faruk A &lt;<a href="mailto:fa@elwak.com">fa@elwak.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi Zeno!<br>
<br>
If i remember correctly i think i got Hunk failed too i had to paste<br>
it manually.<br>
here is my copy already been patched and compiled. If the binary scan<br>
doesn&#39;t work run &quot;make clean&quot; and then &quot;make&quot;<br>
<a href="http://www.zshare.net/download/1322006118c9c70a/" target="_blank">http://www.zshare.net/download/1322006118c9c70a/</a><br>
<font color="#888888"><br>
Faruk<br>
</font><div><div></div><div class="Wj3C7c"><br>
<br>
On Sat, Jun 7, 2008 at 7:17 PM, Zeno Zoli &lt;<a href="mailto:zeno.zoli@gmail.com">zeno.zoli@gmail.com</a>&gt; wrote:<br>
&gt; Tried, and got<br>
&gt;<br>
&gt; Hunk #1 FAILED at 1674.<br>
&gt; Hunk #2 FAILED at 1693.<br>
&gt; Hunk #3 FAILED at 1704.<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Fri, Jun 6, 2008 at 2:50 PM, Faruk A &lt;<a href="mailto:fa@elwak.com">fa@elwak.com</a>&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt; Hi Zeno!<br>
&gt;&gt;<br>
&gt;&gt; Apply this patch.<br>
&gt;&gt;<br>
&gt;&gt; diff -Naur 1/scan.c 2/scan.c<br>
&gt;&gt; --- 1/scan.c &nbsp; &nbsp;2008-04-03 02:00:19.000000000 +0200<br>
&gt;&gt; +++ 2/scan.c &nbsp; &nbsp;2008-04-03 12:29:32.000000000 +0200<br>
&gt;&gt; @@ -1674,15 +1674,18 @@<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; struct dvbfe_info fe_info1;<br>
&gt;&gt; + &nbsp; &nbsp; &nbsp; enum dvbfe_delsys delivery;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; // a temporary hack, need to clean<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; memset(&amp;fe_info1, 0, sizeof (struct dvbfe_info));<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; if(t-&gt;modulation_system == 0)<br>
&gt;&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fe_info1.delivery = DVBFE_DELSYS_DVBS;<br>
&gt;&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;delivery = DVBFE_DELSYS_DVBS;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; else if(t-&gt;modulation_system == 1)<br>
&gt;&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fe_info1.delivery = DVBFE_DELSYS_DVBS2;<br>
&gt;&gt; -<br>
&gt;&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;delivery = DVBFE_DELSYS_DVBS2;<br>
&gt;&gt; +<br>
&gt;&gt; + &nbsp; &nbsp; &nbsp; &nbsp;ioctl(frontend_fd, DVBFE_SET_DELSYS, &amp;delivery); //switch system<br>
&gt;&gt; +<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; int result = ioctl(frontend_fd, DVBFE_GET_INFO, &amp;fe_info1);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; if (result &lt; 0) {<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; perror(&quot;ioctl DVBFE_GET_INFO failed&quot;);<br>
&gt;&gt; @@ -1690,7 +1693,7 @@<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -1;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt;&gt;<br>
&gt;&gt; - &nbsp; &nbsp; &nbsp; &nbsp;switch (fe_info1.delivery) {<br>
&gt;&gt; + &nbsp; &nbsp; &nbsp; &nbsp;switch (delivery) {<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case DVBFE_DELSYS_DVBS:<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; info(&quot;----------------------------------&gt; Using &#39;%s&#39;<br>
&gt;&gt; DVB-S\n&quot;, <a href="http://fe_info.name" target="_blank">fe_info.name</a>);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break;<br>
&gt;&gt; @@ -1701,7 +1704,7 @@<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; info(&quot;----------------------------------&gt; Using &#39;%s&#39;<br>
&gt;&gt; DVB-S2\n&quot;, <a href="http://fe_info.name" target="_blank">fe_info.name</a>);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; default:<br>
&gt;&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;info(&quot;Unsupported Delivery system (%d)!\n&quot;,<br>
&gt;&gt; fe_info1.delivery);<br>
&gt;&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;info(&quot;Unsupported Delivery system (%d)!\n&quot;, delivery);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;last_tuning_failed = 1;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -1;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; 2008/6/6 Zeno Zoli &lt;<a href="mailto:zeno.zoli@gmail.com">zeno.zoli@gmail.com</a>&gt;:<br>
&gt;&gt; &gt; I suppose so<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; wget <a href="http://jusst.de/manu/scan.tar.bz2" target="_blank">http://jusst.de/manu/scan.tar.bz2</a><br>
&gt;&gt; &gt; from <a href="http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI" target="_blank">http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI</a><br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; 2008/6/6 Goga777 &lt;<a href="mailto:goga777@bk.ru">goga777@bk.ru</a>&gt;:<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; which scan version do you use ? does it support the multiproto api ?<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt; I&#39;m new to DVB on linux, but have some linux experience. I have<br>
&gt;&gt; &gt;&gt; &gt; trouble<br>
&gt;&gt; &gt;&gt; &gt; to<br>
&gt;&gt; &gt;&gt; &gt; get my new Terratec Cinergy S2 PCI HD to work properly. I have<br>
&gt;&gt; &gt;&gt; &gt; followed<br>
&gt;&gt; &gt;&gt; &gt; the<br>
&gt;&gt; &gt;&gt; &gt; guide here:<br>
&gt;&gt; &gt;&gt; &gt; <a href="http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI" target="_blank">http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI</a><br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; I get &quot;ioctl DVBFE_GET_INFO failed: Operation not supported&quot;<br>
&gt;&gt; &gt;&gt; &gt; when I try to ./scan -vv dvb-s/Thor-1.0W ( more info below)<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; Could it be related to my choice of Ubuntu 2.6.24-16-server?<br>
&gt;&gt; &gt;&gt; &gt; Thanks for your help.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; Zeno.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; uname -a<br>
&gt;&gt; &gt;&gt; &gt; Linux htpc 2.6.24-16-server #1 SMP i686 GNU/Linux<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; /home/htpc/scan# ./scan -vv dvb-s/Thor-1.0W<br>
&gt;&gt; &gt;&gt; &gt; scanning dvb-s/Thor-1.0W<br>
&gt;&gt; &gt;&gt; &gt; using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>
&gt;&gt; &gt;&gt; &gt; initial transponder 11247000 V 24500000 24500000<br>
&gt;&gt; &gt;&gt; &gt; initial transponder 11293000 H 24500000 24500000<br>
&gt;&gt; &gt;&gt; &gt; initial transponder 11325000 H 24500000 24500000<br>
&gt;&gt; &gt;&gt; &gt; initial transponder 12054000 H 28000000 28000000<br>
&gt;&gt; &gt;&gt; &gt; initial transponder 12169000 H 28000000 28000000<br>
&gt;&gt; &gt;&gt; &gt; initial transponder 12226000 V 28000000 28000000<br>
&gt;&gt; &gt;&gt; &gt; ioctl DVBFE_GET_INFO failed: Operation not supported<br>
&gt;&gt; &gt;&gt; &gt; ioctl DVBFE_GET_INFO failed: Operation not supported<br>
&gt;&gt; &gt;&gt; &gt; ioctl DVBFE_GET_INFO failed: Operation not supported<br>
&gt;&gt; &gt;&gt; &gt; ioctl DVBFE_GET_INFO failed: Operation not supported<br>
&gt;&gt; &gt;&gt; &gt; ioctl DVBFE_GET_INFO failed: Operation not supported<br>
&gt;&gt; &gt;&gt; &gt; ioctl DVBFE_GET_INFO failed: Operation not supported<br>
&gt;&gt; &gt;&gt; &gt; ERROR: initial tuning failed<br>
&gt;&gt; &gt;&gt; &gt; dumping lists (0 services)<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; lsmod<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; lnbp21 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;3200 &nbsp;1 mantis<br>
&gt;&gt; &gt;&gt; &gt; mb86a16 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;21632 &nbsp;1 mantis<br>
&gt;&gt; &gt;&gt; &gt; stb6100 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 8836 &nbsp;1 mantis<br>
&gt;&gt; &gt;&gt; &gt; tda10021 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;7684 &nbsp;1 mantis<br>
&gt;&gt; &gt;&gt; &gt; tda10023 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;7300 &nbsp;1 mantis<br>
&gt;&gt; &gt;&gt; &gt; stb0899 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;36224 &nbsp;1 mantis<br>
&gt;&gt; &gt;&gt; &gt; stv0299 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;11528 &nbsp;1 mantis<br>
&gt;&gt; &gt;&gt; &gt; dvb_core &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 89212 &nbsp;2 mantis,stv0299<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; dmesg<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; &nbsp;36.793511] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (02:09.0),<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 36.793513] &nbsp; &nbsp; Mantis Rev 1 [153b:1179], irq: 20, latency: 64<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 36.793515] &nbsp; &nbsp; memory: 0xfddff000, mmio: 0xf8a54000<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 36.796981] &nbsp; &nbsp; MAC Address=[00:08:ca:1c:a8:e9]<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 36.797011] mantis_alloc_buffers (0): DMA=0x37560000<br>
&gt;&gt; &gt;&gt; &gt; cpu=0xf7560000<br>
&gt;&gt; &gt;&gt; &gt; size=65536<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 36.797061] mantis_alloc_buffers (0): RISC=0x37501000<br>
&gt;&gt; &gt;&gt; &gt; cpu=0xf7501000<br>
&gt;&gt; &gt;&gt; &gt; size=1000<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 36.797107] DVB: registering new adapter (Mantis dvb adapter)<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.345712] stb0899_get_dev_id: Device ID=[8], Release=[2]<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.358369] stb0899_get_dev_id: Demodulator Core ID=[DMD1],<br>
&gt;&gt; &gt;&gt; &gt; Version=[1]<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.371023] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.371074] stb0899_attach: Attaching STB0899<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.371076] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2<br>
&gt;&gt; &gt;&gt; &gt; frontend<br>
&gt;&gt; &gt;&gt; &gt; @0x68<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.371135] stb6100_attach: Attaching STB6100<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.371491] DVB: registering frontend 0 (STB0899 Multistandard)...<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.371523] mantis_ca_init (0): Registering EN50221 device<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.372914] mantis_ca_init (0): Registered EN50221 device<br>
&gt;&gt; &gt;&gt; &gt; [ &nbsp; 37.372973] mantis_hif_init (0): Adapter(0) Initializing Mantis<br>
&gt;&gt; &gt;&gt; &gt; Host<br>
&gt;&gt; &gt;&gt; &gt; Interface<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; lspci -v<br>
&gt;&gt; &gt;&gt; &gt; 02:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV<br>
&gt;&gt; &gt;&gt; &gt; PCI<br>
&gt;&gt; &gt;&gt; &gt; Bridge Controller [Ver 1.0] (rev 01)<br>
&gt;&gt; &gt;&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Subsystem: TERRATEC Electronic GmbH Unknown device 1179<br>
&gt;&gt; &gt;&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Flags: bus master, medium devsel, latency 64, IRQ 20<br>
&gt;&gt; &gt;&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Memory at fddff000 (32-bit, prefetchable) [size=4K]<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; _______________________________________________<br>
&gt;&gt; &gt;&gt; linux-dvb mailing list<br>
&gt;&gt; &gt;&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt;&gt; &gt;&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; _______________________________________________<br>
&gt;&gt; &gt; linux-dvb mailing list<br>
&gt;&gt; &gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt;&gt; &gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;&gt; &gt;<br>
&gt;<br>
&gt;<br>
</div></div></blockquote></div><br>

------=_Part_1690_23464789.1212920996746--


--===============0078225340==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0078225340==--
