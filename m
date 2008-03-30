Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JftEu-0003ax-Kg
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 10:50:11 +0200
Received: by rv-out-0910.google.com with SMTP id b22so726847rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 01:50:03 -0700 (PDT)
Message-ID: <617be8890803300150lb31a16es49686641be49d3e4@mail.gmail.com>
Date: Sun, 30 Mar 2008 10:50:03 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] [PATCH] Add driver specific module option to choose dvb
	adapter numbers, second try
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1986185882=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1986185882==
Content-Type: multipart/alternative;
	boundary="----=_Part_1871_14082126.1206867003147"

------=_Part_1871_14082126.1206867003147
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Great idea. I have myself a Nova-T 500 and an Avermedia A700 and I've
finally had to blacklist both modules for udev and manually loading later
the drivers in the desired order. This is the only way I get always the same
nunbering schema.

If not, I was getting the following crazy situation:

   - dvb0: A700, dvb1/2 for the Nova T-500 when cold booting
   - dvb0 Nova-T 500, dvb1 A700 and dvb2 Nova T-500 again when rebooting

Best regards,
  Eduard


PS and OT: by the way, any progress out there on the Avermedia A700 (please,
Matthias, tell me something positive :D ...?



---------- Missatge reenviat ----------
> From: Janne Grunau <janne-dvb@grunau.be>
> To: linux-dvb@linuxtv.org
> Date: Sat, 29 Mar 2008 22:40:25 +0100
> Subject: [linux-dvb] [PATCH] Add driver specific module option to choose
> dvb adapter numbers, second try
> Hi,
>
> I resubmit this patch since I still think it is a good idea to the this
> driver option. There is still no udev recipe to guaranty stable dvb
> adapter numbers. I've tried to come up with some rules but it's tricky
> due to the multiple device nodes in a subdirectory. I won't claim that
> it is impossible to get udev to assign driver or hardware specific
> stable dvb adapter numbers but I think this patch is easier and more
> clean than a udev based solution.
>
> I'll drop this patch if a simple udev solution is found in a reasonable
> amount of time. But if there is no I would like to see the attached
> patch merged.
>
> Quoting myself for a short desciprtion for the patch:
>
> > V4L drivers have the {radio|vbi|video}_nr module options to allocate
> > static minor numbers per driver.
> >
> > Attached patch adds a similiar mechanism to the dvb subsystem. To
> > avoid problems with device unplugging and repluging each driver holds
> > a DVB_MAX_ADAPTER long array of the preffered order of adapter
> > numbers.
> >
> > options dvb-usb-dib0700 adapter_nr=7,6,5,4,3,2,1,0 would result in a
> > reversed allocation of adapter numbers.
> >
> > With adapter_nr=2,5 it tries first to get adapter number 2 and 5. If
> > both are already in use it will allocate the lowest free adapter
> > number.
>
> Janne
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>

------=_Part_1871_14082126.1206867003147
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div><div>Great idea. I have myself a Nova-T 500 and an Avermedia A700 and I&#39;ve finally had to blacklist both modules for udev and manually loading later the drivers in the desired order. This is the only way I get always the same nunbering schema. <br>
<br>If not, I was getting the following crazy situation:<br><ul><li>dvb0: A700, dvb1/2 for the Nova T-500 when cold booting<br></li><li>dvb0 Nova-T 500, dvb1 A700 and dvb2 Nova T-500 again when rebooting<br></li></ul>Best regards, <br>
&nbsp; Eduard<br><br><br>PS and OT: by the way, any progress out there on the Avermedia A700 (please, Matthias, tell me something positive :D ...?<br><br>&nbsp;</div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
---------- Missatge reenviat ----------<br>From: Janne Grunau &lt;<a href="mailto:janne-dvb@grunau.be">janne-dvb@grunau.be</a>&gt;<br>To: <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>Date: Sat, 29 Mar 2008 22:40:25 +0100<br>
Subject: [linux-dvb] [PATCH] Add driver specific module option to choose dvb adapter numbers, second try<br>Hi,<br> <br> I resubmit this patch since I still think it is a good idea to the this<br> driver option. There is still no udev recipe to guaranty stable dvb<br>
 adapter numbers. I&#39;ve tried to come up with some rules but it&#39;s tricky<br> due to the multiple device nodes in a subdirectory. I won&#39;t claim that<br> it is impossible to get udev to assign driver or hardware specific<br>
 stable dvb adapter numbers but I think this patch is easier and more<br> clean than a udev based solution.<br> <br> I&#39;ll drop this patch if a simple udev solution is found in a reasonable<br> amount of time. But if there is no I would like to see the attached<br>
 patch merged.<br> <br> Quoting myself for a short desciprtion for the patch:<br> <br> &gt; V4L drivers have the {radio|vbi|video}_nr module options to allocate<br> &gt; static minor numbers per driver.<br> &gt;<br> &gt; Attached patch adds a similiar mechanism to the dvb subsystem. To<br>
 &gt; avoid problems with device unplugging and repluging each driver holds<br> &gt; a DVB_MAX_ADAPTER long array of the preffered order of adapter<br> &gt; numbers.<br> &gt;<br> &gt; options dvb-usb-dib0700 adapter_nr=7,6,5,4,3,2,1,0 would result in a<br>
 &gt; reversed allocation of adapter numbers.<br> &gt;<br> &gt; With adapter_nr=2,5 it tries first to get adapter number 2 and 5. If<br> &gt; both are already in use it will allocate the lowest free adapter<br> &gt; number.<br>
 <br> Janne<br> <br>_______________________________________________<br> linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
<br></blockquote></div><br>

------=_Part_1871_14082126.1206867003147--


--===============1986185882==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1986185882==--
