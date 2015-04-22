Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
MIME-Version: 1.0
In-Reply-To: <5537DFD6.50509@fischlustig.de>
References: <CAPAqnGp0poptvEiMOk3oxs7=H8C5DOx-g0qpKZVQGQ_fa20-3Q@mail.gmail.com>
	<55313D2E.1020701@fischlustig.de>
	<CAPAqnGqg0E+sTmsgqW4ccq6k2nDOZYRovaCpPXgyXbdu9GerUQ@mail.gmail.com>
	<5537DFD6.50509@fischlustig.de>
Date: Wed, 22 Apr 2015 23:47:38 +0530
Message-ID: <CAPAqnGou3G67JQNgTTkPQ9NGdmSYvFYwV=1fXaRdM3wBB5RLyg@mail.gmail.com>
From: Mahesh Dl <dl.mahesh@gmail.com>
To: Marek Pikarski <mass@fischlustig.de>
Cc: mass@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DSMCC-MHP-TOOLS incremental carousel updates
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1734579196=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1734579196==
Content-Type: multipart/alternative; boundary=001a1147f2489f54870514542d61

--001a1147f2489f54870514542d61
Content-Type: text/plain; charset=UTF-8

Not really sure. ..but my earlier tool generated a incrementing version (0
to 15) for all modules  (when a change occurred in one or the other modules
)
On 22 Apr 2015 23:22, "Marek Pikarski" <mass@fischlustig.de> wrote:

>  Hello Mahesh,
> are you talking about signalling a certain module version in DII messages?
> Cheers, Marek
>
>
> On 22.04.2015 17:59, Mahesh Dl wrote:
>
> Hello Marek Pikarski,
>
>  Thanks for your prompt reply, it works and i can see the carousel
> updates on a receiver built in my PC. I am stuck with another issue though
> and request your suggestion on this. I was earlier using oc-update utility
> from Avalpa which produces a module_version and my receiver starts the
> application only after verifying the module_version, is there a way that i
> can induce a module_version with dsmcc tools.
>
>  Regards,
> Mahesh
>
> On Fri, Apr 17, 2015 at 10:34 PM, Marek Pikarski <mass@fischlustig.de>
> wrote:
>
>> Hi Mahesh,
>> The idea of incremental updates is as follows:
>> 1. the first time you create a carousel with dsmcc-oc, pass -d option to
>> create a dump
>> 2. modify whatever you want inside your carousel dir
>> 3. call dsmmc-up -in pathtoyour.dump
>>
>> You can repeat steps 2+3 each time you want to produce an incrementally
>> updated carousel.
>> Regards, Marek
>>
>>
>>
>> On 17.04.2015 15:59, Mahesh Dl wrote:
>>
>>> Hello Marek Pikarski,
>>>
>>> First of all thank you for the dsmcc-mhp-tools, it made my test setup
>>> easy for carousel's. It works flawless so far, i use tscbrmuxer from
>>> opencaster for muxing with AV.
>>>
>>> As of now, i  am confused on "updating of version number for the module,
>>> once i update some files or folders in the carousel directory", i guess its
>>> already included in the package as it is mentioned in the README that
>>> incremental updates are supported. Please provide an example of command
>>> usage to achieve this.
>>>
>>> I use the inotify-tools to monitor the directory for carousel and can
>>> generate the new m2t file when ever there is a change in the directory. The
>>> command used to generate the m2t is  - dsmcc-oc --in=/home/root/dsmcc
>>> --out=test4.m2t --pid=0x07d3 -cid 0x00000001 --tag=0xb -ns -v .
>>>
>>> Please help.
>>>
>>> Thanks & Regards,
>>> Mahesh
>>>
>>
>>
>
>

--001a1147f2489f54870514542d61
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Not really sure. ..but my earlier tool generated a increment=
ing version (0 to 15) for all modules=C2=A0 (when a change occurred in one =
or the other modules )</p>
<div class=3D"gmail_quote">On 22 Apr 2015 23:22, &quot;Marek Pikarski&quot;=
 &lt;<a href=3D"mailto:mass@fischlustig.de">mass@fischlustig.de</a>&gt; wro=
te:<br type=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
 =20
   =20
 =20
  <div bgcolor=3D"#FFFFFF" text=3D"#000000">
    <div>Hello Mahesh,<br>
      are you talking about signalling a certain module version in DII
      messages?<br>
      Cheers, Marek<br>
      <br>
      <br>
      On 22.04.2015 17:59, Mahesh Dl wrote:<br>
    </div>
    <blockquote type=3D"cite">
      <div dir=3D"ltr">Hello Marek Pikarski,
        <div><br>
        </div>
        <div>Thanks for your prompt reply, it works and i can see the
          carousel updates on a receiver built in my PC. I am stuck with
          another issue though and request your suggestion on this. I
          was earlier using oc-update utility from Avalpa which produces
          a=C2=A0module_version and my receiver starts the application only
          after verifying the=C2=A0module_version, is there a way that i ca=
n
          induce a=C2=A0module_version with dsmcc tools.</div>
        <div><br>
        </div>
        <div>Regards,</div>
        <div>Mahesh</div>
      </div>
      <div class=3D"gmail_extra"><br>
        <div class=3D"gmail_quote">On Fri, Apr 17, 2015 at 10:34 PM, Marek
          Pikarski <span dir=3D"ltr">&lt;<a href=3D"mailto:mass@fischlustig=
.de" target=3D"_blank">mass@fischlustig.de</a>&gt;</span>
          wrote:<br>
          <blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">Hi Mahesh,<br>
            The idea of incremental updates is as follows:<br>
            1. the first time you create a carousel with dsmcc-oc, pass
            -d option to create a dump<br>
            2. modify whatever you want inside your carousel dir<br>
            3. call dsmmc-up -in pathtoyour.dump<br>
            <br>
            You can repeat steps 2+3 each time you want to produce an
            incrementally updated carousel.<br>
            Regards, Marek
            <div>
              <div><br>
                <br>
                <br>
                On 17.04.2015 15:59, Mahesh Dl wrote:<br>
                <blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex">
                  Hello Marek Pikarski,<br>
                  <br>
                  First of all thank you for the dsmcc-mhp-tools, it
                  made my test setup easy for carousel&#39;s. It works
                  flawless so far, i use tscbrmuxer from opencaster for
                  muxing with AV.<br>
                  <br>
                  As of now, i=C2=A0 am confused on &quot;updating of versi=
on
                  number for the module, once i update some files or
                  folders in the carousel directory&quot;, i guess its
                  already included in the package as it is mentioned in
                  the README that incremental updates are supported.
                  Please provide an example of command usage to achieve
                  this.<br>
                  <br>
                  I use the inotify-tools to monitor the directory for
                  carousel and can generate the new m2t file when ever
                  there is a change in the directory. The command used
                  to generate the m2t is=C2=A0 - dsmcc-oc
                  --in=3D/home/root/dsmcc --out=3Dtest4.m2t --pid=3D0x07d3
                  -cid 0x00000001 --tag=3D0xb -ns -v .<br>
                  <br>
                  Please help.<br>
                  <br>
                  Thanks &amp; Regards,<br>
                  Mahesh<br>
                </blockquote>
                <br>
              </div>
            </div>
          </blockquote>
        </div>
        <br>
      </div>
    </blockquote>
    <br>
  </div>

</blockquote></div>

--001a1147f2489f54870514542d61--


--===============1734579196==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1734579196==--
