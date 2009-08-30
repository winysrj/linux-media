Return-path: <linux-media-owner@vger.kernel.org>
Received: from web112512.mail.gq1.yahoo.com ([98.137.26.166]:25656 "HELO
	web112512.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753054AbZH3BFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 21:05:19 -0400
Message-ID: <113020.97515.qm@web112512.mail.gq1.yahoo.com>
Date: Sat, 29 Aug 2009 17:58:40 -0700 (PDT)
From: Dalton Harvie <dalton_harvie@yahoo.com.au>
Subject: Re: [linux-dvb] Can ir polling be turned off in cx88 module for Leadtek 1000DTV card?
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1377413112-1251593920=:97515"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0-1377413112-1251593920=:97515
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks for looking into this Andy.=0A=0AI modified your patch a bit (attach=
ed) I guess because the kernel version I'm using (ubuntu 8.04, 2.6.24-24) i=
sn't the most recent?=0A=0AAnyway, I have attached the patch incase anyone =
else wants to use it with this particular version.  Also, I had to apply th=
e option (in /etc/modprobe/options)=0A=0Aoptions cx88xx noir=3D1,1=0A=0Arat=
her than to cx88.  Not sure if this is something to do with having an older=
 kernel version, but it worked.  I followed instructions at https://wiki.ub=
untu.com/KernelCustomBuild re building modules.  Now I can turn off or on t=
he polling which is very handy.=0A=0AI'm sure others would find this useful=
 too - can I suggest this as a feature anywhere?  As an extension/alternati=
ve, what about an option to control the rate of polling - setting the rate =
to 0 would disable the polling altogether - not setting it at all would use=
 the default rate.=0A=0A--- On Thu, 8/27/09, Andy Walls <awalls@radix.net> =
wrote:=0A=0A> From: Andy Walls <awalls@radix.net>=0A> Subject: Re: [linux-d=
vb] Can ir polling be turned off in cx88 module for Leadtek 1000DTV card?=
=0A> To: linux-media@vger.kernel.org=0A> Cc: linux-dvb@linuxtv.org=0A> Date=
: Thursday, August 27, 2009, 9:30 AM=0A> On Wed, 2009-08-26 at 07:33 -0700,=
=0A> Dalton Harvie wrote:=0A> > Hi,=0A> > =0A> > I'm no expert with this st=
uff but have been using=0A> mythtv under ubuntu=0A> > for a while.=A0 Latel=
y the machine became quite=0A> sluggish.=0A> > =0A> > I have two Leadtek 10=
00DTV cards and a usb remote in a=0A> ubuntu 8.04=0A> > (2.6.24-24-generic)=
 machine with the standard packaged=0A> kernel.=0A> > =0A> > >From /var/log=
/dmesg=0A> > [=A0=A0=A056.656386] cx88[0]: subsystem:=0A> 107d:665f, board:=
 WinFast DTV1000-T=0A> > [card=3D35,autodetected]=0A> > =0A> > =0A> > I ins=
talled powertop and found that there were 500=0A> wakeups/s occuring=0A> > =
from `run_workqueue (ir_timer)' which I assume is to=0A> do with polling=0A=
> > the built in remote receiver on these tuner=0A> cards.=A0 I no longer u=
se=0A> > these Leadtek remotes, instead using a mceusb type one=0A> - so wo=
uld like=0A> > to stop this polling.=0A> > =0A> > I tried a hack with my li=
mited c knowledge - I edited=0A> cx88-input.c to=0A> > remove all reference=
s to the DTV1000 card (two places)=0A> and recompiled=0A> > the modules.=A0=
 Now the rapid polling has=0A> gone.=A0 The reponse of the new=0A> > mceusb=
 remote seems to be much better now too.=A0=0A> The problem is that I=0A> >=
 don't want to have to recompile these modules each=0A> time there is an=0A=
> > update package to the kernel available.=0A> > =0A> > My question is - i=
s there any way to stop this polling=0A> without having=0A> > to recompile =
the modules?=A0 Some option to pass to=0A> them maybe?=0A> =0A> =0A> No. No=
.=0A> =0A> >=A0=A0=A0If there isn't, would it be a good=0A> idea?=0A> =0A> =
Maybe.=0A> =0A> > Thanks for any help.=0A> =0A> =0A> Try this.=A0 It adds a=
 module option "noir" that accepts=0A> an array of=0A> int's.=A0 For a 0, t=
hat card's IR is set up as normal;=0A> for a 1, that=0A> card's IR is not i=
nitialized.=0A> =0A> =A0=A0=A0 # modprobe cx88 noir=3D1,1=0A> =0A> Regards,=
=0A> Andy=0A> =0A> =0A> cx88: Add module option for disabling IR=0A> =0A> I=
f an IR receiver isn't in use, there's no need to incurr=0A> the penalties=
=0A> for polling.=0A> =0A> Reported-by: Dalton Harvie <dalton_harvie@yahoo.=
com.au>=0A> Signed-off-by: Andy Walls <awalls@radix.net>=0A> =0A> diff -r 2=
8f8b0ebd224=0A> linux/drivers/media/video/cx88/cx88-cards.c=0A> ---=0A> a/l=
inux/drivers/media/video/cx88/cx88-cards.c=A0=A0=A0=0A> Sun Aug 23 13:55:25=
 2009 -0300=0A> +++=0A> b/linux/drivers/media/video/cx88/cx88-cards.c=A0=A0=
=A0=0A> Wed Aug 26 19:23:17 2009 -0400=0A> @@ -32,14 +32,17 @@=0A>  static =
unsigned int tuner[] =3D {[0 ... (CX88_MAXBOARDS -=0A> 1)] =3D UNSET };=0A>=
  static unsigned int radio[] =3D {[0 ... (CX88_MAXBOARDS -=0A> 1)] =3D UNS=
ET };=0A>  static unsigned int card[]=A0 =3D {[0 ... (CX88_MAXBOARDS=0A> - =
1)] =3D UNSET };=0A> +static unsigned int noir[]=A0 =3D {[0 ... (CX88_MAXBO=
ARDS=0A> - 1)] =3D UNSET };=0A>  =0A>  module_param_array(tuner, int, NULL,=
 0444);=0A>  module_param_array(radio, int, NULL, 0444);=0A>  module_param_=
array(card,=A0 int, NULL, 0444);=0A> +module_param_array(noir,=A0 int, NULL=
, 0444);=0A>  =0A>  MODULE_PARM_DESC(tuner,"tuner type");=0A>  MODULE_PARM_=
DESC(radio,"radio tuner type");=0A>  MODULE_PARM_DESC(card,"card type");=0A=
> +MODULE_PARM_DESC(noir, "disable IR (default: 0, IR=0A> enabled)");=0A>  =
=0A>  static unsigned int latency =3D UNSET;=0A>  module_param(latency,int,=
0444);=0A> @@ -3490,7 +3493,8 @@=0A>  =A0=A0=A0 }=0A>  =0A>  =A0=A0=A0 cx88=
_card_setup(core);=0A> -=A0=A0=A0 cx88_ir_init(core, pci);=0A> +=A0=A0=A0 i=
f (!noir[core->nr])=0A> +=A0=A0=A0 =A0=A0=A0 cx88_ir_init(core,=0A> pci);=
=0A>  =0A>  =A0=A0=A0 return core;=0A>  }=0A> =0A> =0A> =0A> ______________=
_________________________________=0A> linux-dvb users mailing list=0A> For =
V4L/DVB development, please use instead linux-media@vger.kernel.org=0A> lin=
ux-dvb@linuxtv.org=0A> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linu=
x-dvb=0A>=0A=0A=0A      
--0-1377413112-1251593920=:97515
Content-Type: application/octet-stream; name="cx88_irpolling_2.6.24-24-generic.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="cx88_irpolling_2.6.24-24-generic.diff"

LS0tIGN4ODgtY2FyZHNfb3JpZ2luYWwuYwkyMDA5LTA4LTI5IDIwOjE3OjQ1
LjAwMDAwMDAwMCArMTAwMAorKysgY3g4OC1jYXJkcy5jCTIwMDktMDgtMzAg
MTA6Mzk6MjEuMDAwMDAwMDAwICsxMDAwCkBAIC0zMCwxNCArMzAsMTcgQEAK
IHN0YXRpYyB1bnNpZ25lZCBpbnQgdHVuZXJbXSA9IHtbMCAuLi4gKENYODhf
TUFYQk9BUkRTIC0gMSldID0gVU5TRVQgfTsKIHN0YXRpYyB1bnNpZ25lZCBp
bnQgcmFkaW9bXSA9IHtbMCAuLi4gKENYODhfTUFYQk9BUkRTIC0gMSldID0g
VU5TRVQgfTsKIHN0YXRpYyB1bnNpZ25lZCBpbnQgY2FyZFtdICA9IHtbMCAu
Li4gKENYODhfTUFYQk9BUkRTIC0gMSldID0gVU5TRVQgfTsKK3N0YXRpYyB1
bnNpZ25lZCBpbnQgbm9pcltdICA9IHtbMCAuLi4gKENYODhfTUFYQk9BUkRT
IC0gMSldID0gVU5TRVQgfTsKIAogbW9kdWxlX3BhcmFtX2FycmF5KHR1bmVy
LCBpbnQsIE5VTEwsIDA0NDQpOwogbW9kdWxlX3BhcmFtX2FycmF5KHJhZGlv
LCBpbnQsIE5VTEwsIDA0NDQpOwogbW9kdWxlX3BhcmFtX2FycmF5KGNhcmQs
ICBpbnQsIE5VTEwsIDA0NDQpOworbW9kdWxlX3BhcmFtX2FycmF5KG5vaXIs
ICBpbnQsIE5VTEwsIDA0NDQpOwogCiBNT0RVTEVfUEFSTV9ERVNDKHR1bmVy
LCJ0dW5lciB0eXBlIik7CiBNT0RVTEVfUEFSTV9ERVNDKHJhZGlvLCJyYWRp
byB0dW5lciB0eXBlIik7CiBNT0RVTEVfUEFSTV9ERVNDKGNhcmQsImNhcmQg
dHlwZSIpOworTU9EVUxFX1BBUk1fREVTQyhub2lyLCAiZGlzYWJsZSBJUiAo
ZGVmYXVsdDogMCwgSVIgZW5hYmxlZCkiKTsKIAogc3RhdGljIHVuc2lnbmVk
IGludCBsYXRlbmN5ID0gVU5TRVQ7CiBtb2R1bGVfcGFyYW0obGF0ZW5jeSxp
bnQsMDQ0NCk7CkBAIC0yMTIwLDcgKzIxMjMsOCBAQAogCWN4ODhfaTJjX2lu
aXQoY29yZSwgcGNpKTsKIAljeDg4X2NhbGxfaTJjX2NsaWVudHMgKGNvcmUs
IFRVTkVSX1NFVF9TVEFOREJZLCBOVUxMKTsKIAljeDg4X2NhcmRfc2V0dXAo
Y29yZSk7Ci0JY3g4OF9pcl9pbml0KGNvcmUsIHBjaSk7CisvKiBjeDg4X2ly
X2luaXQoY29yZSwgcGNpKTsgKi8KKyAgaWYgKCFub2lyW2NvcmUtPm5yXSkg
Y3g4OF9pcl9pbml0KGNvcmUsIHBjaSk7CiAKIAlyZXR1cm4gY29yZTsKIH0K


--0-1377413112-1251593920=:97515--
