Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nASI4rYU023035
	for <video4linux-list@redhat.com>; Sat, 28 Nov 2009 13:04:53 -0500
Received: from web28411.mail.ukl.yahoo.com (web28411.mail.ukl.yahoo.com
	[87.248.110.160])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nASI4bSs003522
	for <video4linux-list@redhat.com>; Sat, 28 Nov 2009 13:04:37 -0500
Message-ID: <573897.98809.qm@web28411.mail.ukl.yahoo.com>
References: <19415111.1258842824951.JavaMail.ngmail@webmail09.arcor-online.net>
	<6ab2c27e0911220451y1777caaelc54dd9e70b974bac@mail.gmail.com>
	<1258929022.7524.6.camel@pc07.localdom.local>
	<6ab2c27e0911221723v5479a179kbe42a67ebb53a797@mail.gmail.com>
	<6ab2c27e0911221742g739380d1m10b517d25f451898@mail.gmail.com>
	<1258943427.3257.28.camel@pc07.localdom.local>
	<6ab2c27e0911251833t7407c942mfaec1ee0ff636e7b@mail.gmail.com>
	<1259377768.3267.11.camel@pc07.localdom.local>
Date: Sat, 28 Nov 2009 18:04:36 +0000 (GMT)
From: Pavle Predic <pavle.predic@yahoo.co.uk>
To: hermann pitton <hermann-pitton@arcor.de>, Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <1259377768.3267.11.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: Re: Re: Leadtek Winfast TV2100
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hey guys,=0A=0ALet me start by thanking you both for all your help. Unfortu=
nately, there isn't much I can do with the data you provided - it's way too=
 technical for me. I'd be happy to do any tests and apply any patches, but =
I would need some instructions - but only if you have time; I really don't =
want to burden you with this. =0A=0AThanks again,=0A=0APavle.=0A=0A=0A=0A__=
______________________________=0AFrom: hermann pitton <hermann-pitton@arcor=
.de>=0ATo: Terry Wu <terrywu2009@gmail.com>=0ACc: pavle.predic@yahoo.co.uk;=
 video4linux-list@redhat.com=0ASent: Sat, 28 November, 2009 4:09:28=0ASubje=
ct: Re: Re: Leadtek Winfast TV2100=0A=0AHi Terry Wu,=0A=0AAm Donnerstag, de=
n 26.11.2009, 10:33 +0800 schrieb Terry Wu:=0A> Hi,=0A> =0A> Here are the s=
ubsystem IDs for different TV2100 models:=0A>     Subsystem ID:0x6f30107d, =
TVF8533-BDF (PAL BG/DK)=0A>     Subsystem ID:0x6f32107d, TVF5533-MF (NTSC)=
=0A>     Subsystem ID:0x6f3a107d, TVF88T5-B/DFF (PAL BG/DK, FM)=0A> =0A> Te=
rry=0A=0Abetter is to become active on it.=0A=0Awe can most likely help abo=
ut how to match such tuners fine,=0Aif any doubts left, but the best is to =
send just patches with having=0Asuch hardware to test on.=0A=0ACompared to =
the early tda9887 stuff on LeadTek devices, LeadTek was=0Apioneering and we=
 have that in mind, it should be fairly easy for those.=0A=0ALet's know the=
 other way round too, where you have still concerns doing=0Aso.=0A=0ACheers=
,=0AHermann=0A=0A> 2009/11/23 hermann pitton <hermann-pitton@arcor.de>:=0A>=
 > Hi, thanks again!=0A> >=0A> > Am Montag, den 23.11.2009, 09:42 +0800 sch=
rieb Terry Wu:=0A> >> Hi,=0A> >>=0A> >>     Please refer to the attached JP=
EG file for the GPIO settings of=0A> >> TV2100 with FM (PCB:B).=0A> >>=0A> =
>>     Let me know if you need the information of TV2100 without FM=0A> >> =
(PCB:A, TVF8533-BDF).=0A> >>=0A> >> Terry Wu=0A> >=0A> > On a first look, i=
f we start to count gpios from zero, we tell the same.=0A> >=0A> > The TVF8=
533_BDF I would have to look up. It is four to five years back.=0A> >=0A> >=
 If it uses that minor number TI chip without radio support, we treat it=0A=
> > as tuner=3D69 too currently.=0A> >=0A> > For all such older can tuners,=
 widely different about the globe, counts,=0A> > that we don't have any way=
 to detect them. So first working, either NTSC=0A> > or PAL, sits in the po=
ol position and others have to think twice.=0A> >=0A> > OEMs do code tuners=
 into eeprom content, some do not at all, such doing=0A> > it are in compet=
ition and don't follow the rules of the main chip=0A> > manufacturer, Phili=
ps/NXP in that case, and go their own ways.=0A> >=0A> > So tuner tables are=
 unstable across manufacturers.=0A> >=0A> > We often can't help that much i=
n such cases, but implementing their own=0A> > tuner eeprom detection into =
the linux drivers is of course still=0A> > welcome. Hauppauge does it very =
successfully since years.=0A> >=0A> > We can't do much about it, if OEMs do=
n't follow Philips or whom ever on=0A> > such.=0A> >=0A> > Thanks,=0A> > He=
rmann=0A> >=0A> >=0A> >>=0A> >> 2009/11/23 Terry Wu <terrywu2009@gmail.com>=
:=0A> >> > Hi,=0A> >> >=0A> >> >    The TVF88T5-BDFF data sheet is attached=
.=0A> >> >=0A> >> > Terry Wu=0A> >> >=0A> >> > 11/17/2003  06:39 PM        =
    72,010 TVF5531-MF.pdf=0A> >> > 03/12/2008  11:37 AM           555,285 T=
VF5533-MF-.pdf=0A> >> > 02/24/2004  02:19 PM           120,727 TVF5533-MF.p=
df=0A> >> > 12/30/2003  06:59 PM            91,577 TVF5831-MFF.pdf=0A> >> >=
 09/26/2005  10:20 AM           156,853 TVF78P3-MFF.pdf=0A> >> > 11/17/2003=
  06:39 PM            67,947 TVF8531-BDF.pdf=0A> >> > 11/17/2003  06:39 PM =
           67,715 TVF8531-DIF.pdf=0A> >> > 03/12/2008  11:37 AM           5=
09,340 TVF8533-BDF.pdf=0A> >> > 03/12/2008  11:37 AM           507,295 TVF8=
533-DIF.pdf=0A> >> > 12/30/2003  06:59 PM            87,921 TVF8831-BDFF.pd=
f=0A> >> > 12/30/2003  06:59 PM            87,624 TVF8831-DIFF.pdf=0A> >> >=
 09/26/2005  10:20 AM           176,525 TVF88P3-CFF.pdf=0A> >> > 03/24/2006=
  10:48 AM           460,941 TVF88T5-BDFF.pdf=0A> >> > 02/24/2004  02:19 PM=
           132,304 TVF9533-BDF.pdf=0A> >> > 02/24/2004  02:19 PM           =
120,940 TVF9533-DIF.pdf=0A> >> > 03/12/2008  11:37 AM           458,967 TVF=
99T5-BDFF.pdf=0A> >> >=0A> >=0A> >=0A> >=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
