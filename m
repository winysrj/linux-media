Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KRzxY-0001Ma-9c
	for linux-dvb@linuxtv.org; Sun, 10 Aug 2008 03:43:08 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	31A2B1800FC9
	for <linux-dvb@linuxtv.org>; Sun, 10 Aug 2008 01:42:26 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1218332545157091"
MIME-Version: 1.0
From: stev391@email.com
To: "Jonathan Hummel" <jhhummel@bigpond.com>
Date: Sun, 10 Aug 2008 11:42:25 +1000
Message-Id: <20080810014226.07EFF47808F@ws1-5.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--_----------=_1218332545157091
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1218332545157090"

This is a multi-part message in MIME format.

--_----------=_1218332545157090
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

  ----- Original Message -----
  From: "Jonathan Hummel"
  To: stev391@email.com
  Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H -
  DVB Only support
  Date: Sat, 09 Aug 2008 21:48:21 +1000


  Hi All,

  Finnaly got some time to give the patch a go. I used the pacakges
  Stephen, sent the link to, not Mark's. I cant't get past the attached
  problem. The dmesg output is attached. I tried setting the card like
  this:
  /etc/modprobe.d/options file and add the line: options cx88xx card=3D11
  I also tried the following two varients:
  cx23885 card=3D11
  cx23885 card=3D12

  I also got what looked like an error message when applying the first
  patch, something like "strip count 1 is not a number" (although 1 not
  being a number would explain my difficulties with maths!)

  Cheers

  Jon

  On Wed, 2008-08-06 at 07:33 +1000, stev391@email.com wrote:
  > Mark, Jon,
  >
  > The patches I made were not against the v4l-dvb tip that is
  referenced
  > in Mark's email below. I did this on purpose because there is a
  small
  > amount of refactoring (recoding to make it better) being performed
  by
  > Steven Toth and others.
  >
  > To get the version I used for the patch download (This is for the
  > first initial patch [you can tell it is this one as the patch file
  > mentions cx23885-sram in the path]):
  > http://linuxtv.org/hg/~stoth/cx23885-sram/archive/tip.tar.gz
  >
  > For the second patch that emailed less then 12 hours ago download
  this
  > version of drivers:
  > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.gz
  > and then apply my patch (this patch mentions v4l-dvb). This version
  is
  > a cleanup of the previous and uses the generic callback function.
  >
  > Other then that you are heading in the correct direction...
  >
  > Do either of you have the same issue I have that when the computer
  is
  > first turned on the autodetect card feature doesn't work due to
  > subvendor sub product ids of 0000? Or is just a faulty card that I
  > have?
  >
  > Regards,
  >
  > Stephen.
  > ----- Original Message -----
  > From: "Mark Carbonaro" To: "Jonathan Hummel"
  > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
  > 3200 H - DVB Only support
  > Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)
  >
  >
  > Hi Mark,
  >
  > Forgive my ignorance/ newbie-ness, but what do I do with that
  > patch code
  > below? is there a tutorial or howto or something somewhere
  > that will
  > introduce me to this. I have done some programming, but
  > nothing of this
  > level.
  >
  > cheers
  >
  > Jon
  >
  > ----- Original Message -----
  > From: "Jonathan Hummel" To: "Mark Carbonaro"
  > Cc: stev391@email.com, linux-dvb@linuxtv.org
  > Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000)
  > Auto-Detected
  > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
  > 3200 H - DVB Only support
  >
  > Hi Jon,
  >
  > Not a problem at all, I'm new to this myself, below is what
  > went through and I may not be doing it the right
  > way either. So if anyone would like to point out what I
  > am doing wrong I would
  > really appreciate it.
  >
  > The file that I downloaded was called
  > v4l-dvb-2bade2ed7ac8.tar.bz2 which I downloaded
  > from
  > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I
  > also saved the patch to the same location as the download.
  >
  > The patch didn't apply for me, so I manually patched applied
  > the patches and created a new diff that should
  > hopefully work for
  > you also (attached and inline below). From what I
  > could see the offsets in Stephens patch were a little off
  > for this code
  > snapshot but otherwise it is all good.
  >
  > I ran the following using the attached diff...
  >
  > tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2
  > cd v4l-dvb-2bade2ed7ac8
  > patch -p1 < ../Leadtek.Winfast.PxDVR.3200.H.2.diff
  >
  > Once the patch was applied I was then able to build and
  > install the modules as per the instructions in
  > the INSTALL file. I ran
  > the following...
  >
  > make all
  > sudo make install
  >
  > From there I could load the modules and start testing.
  >
  > I hope this helps you get started.
  >
  > Regards,
  > Mark
  >
  >
  >
  >
  >
  >


Jon,

The patch did not apply correctly as the dmesg should list an extra entry
in card list (number 12), and it should have autodetected.

Attached is the newest copy of the patch (save this in the same directory
that you use the following commands from), just to avoid confusion.
Following the following:
wget http://linuxtv.org/hg/~stoth/v4l-dvb/archive/2bade2ed7ac8.tar.gz
tar -xf 2bade2ed7ac8.tar.gz
cd v4l-dvb-2bade2ed7ac8
patch -p1 <../Leadtek_Winfast_PxDVR3200_H.diff
make
sudo make install
sudo make unload
sudo modprobe cx23885

Now the card should have been detected and you should have /dev/adapterN/
(where N is a number). If it hasn't been detected properly you should see
a list of cards in dmesg with the card as number 12. Unload the module
(sudo rmmod cx23885) and then load it with the option card=3D12 (sudo
modprobe cx23885 card=3D12)

For further instructions on how to watch digital tv look at the wiki page
(you need to create a channels.conf).

Regards,
Stephen

P.S.
Please make sure you cc the linux dvb mailing list, so if anyone else has
the same issue we can work together to solve it.
Also the convention is to post your message at the bottom (I got caught
by this one until recently).

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1218332545157090
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"


<div>


<div><br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Jonathan Hummel" <jhhummel@bigpond.com><br>
To: stev391@email.com<br>
Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB	On=
ly support<br>
Date: Sat, 09 Aug 2008 21:48:21 +1000<br>
<br>

<br>
Hi All,<br>
<br>
Finnaly got some time to give the patch a go. I used the pacakges<br>
Stephen, sent the link to, not Mark's. I cant't get past the attached<br>
problem. The dmesg output is attached. I tried setting the card like<br>
this:<br>
/etc/modprobe.d/options file and add the line: options cx88xx card=3D11<br>
I also tried the following two varients:<br>
cx23885 card=3D11<br>
cx23885 card=3D12<br>
<br>
I also got what looked like an error message when applying the first<br>
patch, something like "strip count 1 is not a number" (although 1 not<br>
being a number would explain my difficulties with maths!)<br>
<br>
Cheers<br>
<br>
Jon<br>
<br>
On Wed, 2008-08-06 at 07:33 +1000, stev391@email.com wrote:<br>
&gt; Mark, Jon,<br>
&gt;<br>
&gt; The patches I made were not against the v4l-dvb tip that is referenced=
<br>
&gt; in Mark's email below.  I did this on purpose because there is a small=
<br>
&gt; amount of refactoring (recoding to make it better) being performed by<=
br>
&gt; Steven Toth and others.<br>
&gt;<br>
&gt; To get the version I used for the patch download (This is for the<br>
&gt; first initial patch [you can tell it is this one as the patch file<br>
&gt; mentions cx23885-sram in the path]):<br>
&gt; http://linuxtv.org/hg/~stoth/cx23885-sram/archive/tip.tar.gz<br>
&gt;<br>
&gt; For the second patch that emailed less then 12 hours ago download this=
<br>
&gt; version of drivers:<br>
&gt; http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.gz<br>
&gt; and then apply my patch (this patch mentions v4l-dvb). This version is=
<br>
&gt; a cleanup of the previous and uses the generic callback function.<br>
&gt;<br>
&gt; Other then that you are heading in the correct direction...<br>
&gt;<br>
&gt; Do either of you have the same issue I have that when the computer is<=
br>
&gt; first turned on the autodetect card feature doesn't work due to<br>
&gt; subvendor sub product ids of 0000? Or is just a faulty card that I<br>
&gt; have?<br>
&gt;<br>
&gt; Regards,<br>
&gt;<br>
&gt; Stephen.<br>
&gt;         ----- Original Message -----<br>
&gt;         From: "Mark Carbonaro"         To: "Jonathan Hummel"      <br>
&gt;    Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR<br>
&gt;         3200 H - DVB Only support<br>
&gt;         Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)<br>
&gt;<br>
&gt;<br>
&gt;         Hi Mark,<br>
&gt;<br>
&gt;         Forgive my ignorance/ newbie-ness, but what do I do with that<=
br>
&gt;         patch code<br>
&gt;         below? is there a tutorial or howto or something somewhere<br>
&gt;         that will<br>
&gt;         introduce me to this. I have done some programming, but<br>
&gt;         nothing of this<br>
&gt;         level.<br>
&gt;<br>
&gt;         cheers<br>
&gt;<br>
&gt;         Jon<br>
&gt;<br>
&gt;         ----- Original Message -----<br>
&gt;         From: "Jonathan Hummel"         To: "Mark Carbonaro"      <br>
&gt;    Cc: stev391@email.com, linux-dvb@linuxtv.org<br>
&gt;         Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000)<br>
&gt;         Auto-Detected<br>
&gt;         Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR<br>
&gt;         3200 H         - DVB Only support<br>
&gt;<br>
&gt;         Hi Jon,<br>
&gt;<br>
&gt;         Not a problem at all, I'm new to this myself, below is what<br>
&gt;         went         through and I may not be doing it the right <br>
&gt; way either. So if         anyone would like to point out what I <br>
&gt; am doing wrong I would<br>
&gt;         really         appreciate it.<br>
&gt;<br>
&gt;         The file that I downloaded was called<br>
&gt;         v4l-dvb-2bade2ed7ac8.tar.bz2         which I downloaded <br>
&gt; from         <br>
&gt; http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I<br>
&gt;         also         saved the patch to the same location as the downl=
oad.<br>
&gt;<br>
&gt;         The patch didn't apply for me, so I manually patched applied<b=
r>
&gt;         the         patches and created a new diff that should <br>
&gt; hopefully work for<br>
&gt;         you         also (attached and inline below). From what I <br>
&gt; could see the         offsets in Stephens patch were a little off <br>
&gt; for this code<br>
&gt;         snapshot         but otherwise it is all good.<br>
&gt;<br>
&gt;         I ran the following using the attached diff...<br>
&gt;<br>
&gt;         tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2<br>
&gt;         cd v4l-dvb-2bade2ed7ac8<br>
&gt;         patch -p1 &lt; ../Leadtek.Winfast.PxDVR.3200.H.2.diff<br>
&gt;<br>
&gt;         Once the patch was applied I was then able to build and<br>
&gt;         install the         modules as per the instructions in <br>
&gt; the INSTALL file. I ran<br>
&gt;         the         following...<br>
&gt;<br>
&gt;         make all<br>
&gt;         sudo make install<br>
&gt;<br>
&gt;         From there I could load the modules and start testing.<br>
&gt;<br>
&gt;         I hope this helps you get started.<br>
&gt;<br>
&gt;         Regards,<br>
&gt;         Mark<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
</jhhummel@bigpond.com><br><br></blockquote>Jon,<br><br>The patch did not a=
pply correctly as the dmesg should list an extra entry in card list (number=
 12), and it should have autodetected.<br><br>Attached is the newest copy o=
f the patch (save this in the same directory that you use the following com=
mands from), just to avoid confusion. <br>Following the following:<br>wget =
http://linuxtv.org/hg/~stoth/v4l-dvb/archive/2bade2ed7ac8.tar.gz<br>tar -xf=
 2bade2ed7ac8.tar.gz<br>cd v4l-dvb-2bade2ed7ac8<br>patch -p1 &lt;../Leadtek=
_Winfast_PxDVR3200_H.diff<br>make<br>sudo make install<br>sudo make unload<=
br>sudo modprobe cx23885<br><br>Now the card should have been detected and =
you should have /dev/adapterN/ (where N is a number). If it hasn't been det=
ected properly you should see a list of cards in dmesg with the card as num=
ber 12. Unload the module (sudo rmmod cx23885) and then load it with the op=
tion card=3D12 (sudo modprobe cx23885 card=3D12)<br><br>For further instruc=
tions on how to watch digital tv look at the wiki page (you need to create =
a channels.conf).<br><br>Regards,<br>Stephen<br><br>P.S.<br>Please make sur=
e you cc the linux dvb mailing list, so if anyone else has the same issue w=
e can work together to solve it.<br>Also the convention is to post your mes=
sage at the bottom (I got caught by this one until recently).<br></div>


</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_1218332545157090--


--_----------=_1218332545157091
Content-Disposition: attachment; filename="Leadtek_Winfast_PxDVR3200_H.diff"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="Leadtek_Winfast_PxDVR3200_H.diff"

ZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L0RvY3VtZW50YXRpb24vdmlkZW80
bGludXgvQ0FSRExJU1QuY3gyMzg4NSB2NGwtZHZiMi9saW51eC9Eb2N1bWVu
dGF0aW9uL3ZpZGVvNGxpbnV4L0NBUkRMSVNULmN4MjM4ODUKLS0tIHY0bC1k
dmIvbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5j
eDIzODg1CTIwMDgtMDgtMDUgMTY6NDg6MTMuMDAwMDAwMDAwICsxMDAwCisr
KyB2NGwtZHZiMi9saW51eC9Eb2N1bWVudGF0aW9uL3ZpZGVvNGxpbnV4L0NB
UkRMSVNULmN4MjM4ODUJMjAwOC0wOC0wNSAyMDowNzoxNi4wMDAwMDAwMDAg
KzEwMDAKQEAgLTEwLDMgKzEwLDQgQEAKICAgOSAtPiBIYXVwcGF1Z2UgV2lu
VFYtSFZSMTQwMCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWzAwNzA6
ODAxMF0KICAxMCAtPiBEVmlDTyBGdXNpb25IRFRWNyBEdWFsIEV4cHJlc3Mg
ICAgICAgICAgICAgICAgICAgICAgWzE4YWM6ZDYxOF0KICAxMSAtPiBEVmlD
TyBGdXNpb25IRFRWIERWQi1UIER1YWwgRXhwcmVzcyAgICAgICAgICAgICAg
ICAgWzE4YWM6ZGI3OF0KKyAxMiAtPiBMZWFkdGVrIFdpbmZhc3QgUHhEVlIz
MjAwIEggICAgICAgICAgICAgICAgICAgICAgICAgWzEwN2Q6NjY4MV0KZGlm
ZiAtTmF1ciB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gy
Mzg4NS9jeDIzODg1LWNhcmRzLmMgdjRsLWR2YjIvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2FyZHMuYwotLS0gdjRsLWR2
Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1j
YXJkcy5jCTIwMDgtMDgtMDUgMTY6NDg6MTQuMDAwMDAwMDAwICsxMDAwCisr
KyB2NGwtZHZiMi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUv
Y3gyMzg4NS1jYXJkcy5jCTIwMDgtMDgtMDUgMjE6Mjk6NTkuMDAwMDAwMDAw
ICsxMDAwCkBAIC0xNTUsNiArMTU1LDEwIEBACiAJCS5wb3J0YgkJPSBDWDIz
ODg1X01QRUdfRFZCLAogCQkucG9ydGMJCT0gQ1gyMzg4NV9NUEVHX0RWQiwK
IAl9LAorCVtDWDIzODg1X0JPQVJEX0xFQURURUtfV0lORkFTVF9QWERWUjMy
MDBfSF0gPSB7CisJCS5uYW1lCQk9ICJMZWFkdGVrIFdpbmZhc3QgUHhEVlIz
MjAwIEgiLAorCQkucG9ydGMJCT0gQ1gyMzg4NV9NUEVHX0RWQiwKKwl9LAog
fTsKIGNvbnN0IHVuc2lnbmVkIGludCBjeDIzODg1X2Jjb3VudCA9IEFSUkFZ
X1NJWkUoY3gyMzg4NV9ib2FyZHMpOwogCkBAIC0yMzAsNyArMjM0LDExIEBA
CiAJCS5zdWJ2ZW5kb3IgPSAweDE4YWMsCiAJCS5zdWJkZXZpY2UgPSAweGRi
NzgsCiAJCS5jYXJkICAgICAgPSBDWDIzODg1X0JPQVJEX0RWSUNPX0ZVU0lP
TkhEVFZfRFZCX1RfRFVBTF9FWFAsCi0JfSwKKwl9LHsKKyAJCS5zdWJ2ZW5k
b3IgPSAweDEwN2QsCisgCQkuc3ViZGV2aWNlID0gMHg2NjgxLAorIAkJLmNh
cmQgICAgICA9IENYMjM4ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYRFZS
MzIwMF9ILAorICAJfSwKIH07CiBjb25zdCB1bnNpZ25lZCBpbnQgY3gyMzg4
NV9pZGNvdW50ID0gQVJSQVlfU0laRShjeDIzODg1X3N1Ymlkcyk7CiAKQEAg
LTM1Myw2ICszNjEsMTAgQEAKIAkJaWYgKGNvbW1hbmQgPT0gMCkKIAkJCWJp
dG1hc2sgPSAweDA0OwogCQlicmVhazsKKwljYXNlIENYMjM4ODVfQk9BUkRf
TEVBRFRFS19XSU5GQVNUX1BYRFZSMzIwMF9IOgorCQkvKiBUdW5lciBSZXNl
dCBDb21tYW5kICovCisJCWJpdG1hc2sgPSAweDAwMDcwNDA0OworCQlicmVh
azsKIAljYXNlIENYMjM4ODVfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl83X0RV
QUxfRVhQOgogCWNhc2UgQ1gyMzg4NV9CT0FSRF9EVklDT19GVVNJT05IRFRW
X0RWQl9UX0RVQUxfRVhQOgogCQlpZiAoY29tbWFuZCA9PSAwKSB7CkBAIC00
OTIsNiArNTA0LDE1IEBACiAJCW1kZWxheSgyMCk7CiAJCWN4X3NldChHUDBf
SU8sIDB4MDAwZjAwMGYpOwogCQlicmVhazsKKwljYXNlIENYMjM4ODVfQk9B
UkRfTEVBRFRFS19XSU5GQVNUX1BYRFZSMzIwMF9IOgorCQkvKiBHUElPLTIg
IHhjMzAyOCB0dW5lciByZXNldCAqLworCQkvKiBQdXQgdGhlIHBhcnRzIGlu
dG8gcmVzZXQgYW5kIGJhY2sgKi8KKwkJY3hfc2V0KEdQMF9JTywgMHgwMDA0
MDAwMCk7CisJCW1kZWxheSgyMCk7CisJCWN4X2NsZWFyKEdQMF9JTywgMHgw
MDAwMDAwNCk7CisJCW1kZWxheSgyMCk7CisJCWN4X3NldChHUDBfSU8sIDB4
MDAwNDAwMDQpOworCQlicmVhazsKIAl9CiB9CiAKQEAgLTU3OSw2ICs2MDAs
NyBAQAogCWNhc2UgQ1gyMzg4NV9CT0FSRF9IQVVQUEFVR0VfSFZSMTIwMDoK
IAljYXNlIENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hWUjE3MDA6CiAJY2Fz
ZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxNDAwOgorCWNhc2UgQ1gy
Mzg4NV9CT0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhEVlIzMjAwX0g6CiAJZGVm
YXVsdDoKIAkJdHMyLT5nZW5fY3RybF92YWwgID0gMHhjOyAvKiBTZXJpYWwg
YnVzICsgcHVuY3R1cmVkIGNsb2NrICovCiAJCXRzMi0+dHNfY2xrX2VuX3Zh
bCA9IDB4MTsgLyogRW5hYmxlIFRTX0NMSyAqLwpAQCAtNTkyLDYgKzYxNCw3
IEBACiAJY2FzZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxODAwOgog
CWNhc2UgQ1gyMzg4NV9CT0FSRF9IQVVQUEFVR0VfSFZSMTgwMGxwOgogCWNh
c2UgQ1gyMzg4NV9CT0FSRF9IQVVQUEFVR0VfSFZSMTcwMDoKKwljYXNlIENY
MjM4ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYRFZSMzIwMF9IOgogCQly
ZXF1ZXN0X21vZHVsZSgiY3gyNTg0MCIpOwogCQlicmVhazsKIAl9CmRpZmYg
LU5hdXIgdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4
ODUvY3gyMzg4NS1kdmIuYyB2NGwtZHZiMi9saW51eC9kcml2ZXJzL21lZGlh
L3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYwotLS0gdjRsLWR2Yi9saW51
eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYwky
MDA4LTA4LTA1IDE2OjQ4OjE0LjAwMDAwMDAwMCArMTAwMAorKysgdjRsLWR2
YjIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUt
ZHZiLmMJMjAwOC0wOC0wNSAyMToyOTowMC4wMDAwMDAwMDAgKzEwMDAKQEAg
LTM3LDYgKzM3LDcgQEAKICNpbmNsdWRlICJ0ZGE4MjkwLmgiCiAjaW5jbHVk
ZSAidGRhMTgyNzEuaCIKICNpbmNsdWRlICJsZ2R0MzMweC5oIgorI2luY2x1
ZGUgInpsMTAzNTMuaCIKICNpbmNsdWRlICJ4YzUwMDAuaCIKICNpbmNsdWRl
ICJ0ZGExMDA0OC5oIgogI2luY2x1ZGUgInR1bmVyLXhjMjAyOC5oIgpAQCAt
NTAyLDYgKzUwMywzMiBAQAogCQl9CiAJCWJyZWFrOwogCX0KKyAJY2FzZSBD
WDIzODg1X0JPQVJEX0xFQURURUtfV0lORkFTVF9QWERWUjMyMDBfSDoKKyAJ
CWkyY19idXMgPSAmZGV2LT5pMmNfYnVzWzBdOworIAorIAkJcG9ydC0+ZHZi
LmZyb250ZW5kID0gZHZiX2F0dGFjaCh6bDEwMzUzX2F0dGFjaCwKKyAJCQkJ
CSAgICAgICAmZHZpY29fZnVzaW9uaGR0dl94YzMwMjgsCisgCQkJCQkgICAg
ICAgJmkyY19idXMtPmkyY19hZGFwKTsKKyAJCWlmIChwb3J0LT5kdmIuZnJv
bnRlbmQgIT0gTlVMTCkgeworIAkJCXN0cnVjdCBkdmJfZnJvbnRlbmQgICAg
ICAqZmU7CisgCQkJc3RydWN0IHhjMjAyOF9jb25maWcJICBjZmcgPSB7Cisg
CQkJCS5pMmNfYWRhcCAgPSAmZGV2LT5pMmNfYnVzWzFdLmkyY19hZGFwLAor
IAkJCQkuaTJjX2FkZHIgID0gMHg2MSwKKyAJCQkJLnZpZGVvX2RldiA9IHBv
cnQsCisgCQkJCS5jYWxsYmFjayAgPSBjeDIzODg1X3R1bmVyX2NhbGxiYWNr
LAorIAkJCX07CisgCQkJc3RhdGljIHN0cnVjdCB4YzIwMjhfY3RybCBjdGwg
PSB7CisgCQkJCS5mbmFtZSAgICAgICA9ICJ4YzMwMjgtdjI3LmZ3IiwKKyAJ
CQkJLm1heF9sZW4gICAgID0gNjQsCisgCQkJCS5kZW1vZCAgICAgICA9IFhD
MzAyOF9GRV9aQVJMSU5LNDU2LAorIAkJCX07CisgCisgCQkJZmUgPSBkdmJf
YXR0YWNoKHhjMjAyOF9hdHRhY2gsIHBvcnQtPmR2Yi5mcm9udGVuZCwKKyAJ
CQkJCSZjZmcpOworIAkJCWlmIChmZSAhPSBOVUxMICYmIGZlLT5vcHMudHVu
ZXJfb3BzLnNldF9jb25maWcgIT0gTlVMTCkKKyAJCQkJZmUtPm9wcy50dW5l
cl9vcHMuc2V0X2NvbmZpZyhmZSwgJmN0bCk7CisgCQl9CisgCQlicmVhazsK
IAlkZWZhdWx0OgogCQlwcmludGsoIiVzOiBUaGUgZnJvbnRlbmQgb2YgeW91
ciBEVkIvQVRTQyBjYXJkIGlzbid0IHN1cHBvcnRlZCB5ZXRcbiIsCiAJCSAg
ICAgICBkZXYtPm5hbWUpOwpkaWZmIC1OYXVyIHY0bC1kdmIvbGludXgvZHJp
dmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUuaCB2NGwtZHZiMi9s
aW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS5oCi0t
LSB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9j
eDIzODg1LmgJMjAwOC0wOC0wNSAxNjo0ODoxNC4wMDAwMDAwMDAgKzEwMDAK
KysrIHY0bC1kdmIyL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4
NS9jeDIzODg1LmgJMjAwOC0wOC0wNSAyMDoxMDo1Ny4wMDAwMDAwMDAgKzEw
MDAKQEAgLTY2LDYgKzY2LDcgQEAKICNkZWZpbmUgQ1gyMzg4NV9CT0FSRF9I
QVVQUEFVR0VfSFZSMTQwMCAgICAgICAgOQogI2RlZmluZSBDWDIzODg1X0JP
QVJEX0RWSUNPX0ZVU0lPTkhEVFZfN19EVUFMX0VYUCAxMAogI2RlZmluZSBD
WDIzODg1X0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZfRFZCX1RfRFVBTF9FWFAg
MTEKKyNkZWZpbmUgQ1gyMzg4NV9CT0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhE
VlIzMjAwX0ggMTIKIAogLyogQ3VycmVudGx5IHVuc3VwcG9ydGVkIGJ5IHRo
ZSBkcml2ZXI6IFBBTC9ILCBOVFNDL0tyLCBTRUNBTSBCL0cvSC9MQyAqLwog
I2RlZmluZSBDWDIzODg1X05PUk1TIChcCmRpZmYgLU5hdXIgdjRsLWR2Yi9s
aW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvS2NvbmZpZyB2NGwt
ZHZiMi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvS2NvbmZp
ZwotLS0gdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4
ODUvS2NvbmZpZwkyMDA4LTA4LTA1IDE2OjQ4OjE0LjAwMDAwMDAwMCArMTAw
MAorKysgdjRsLWR2YjIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIz
ODg1L0tjb25maWcJMjAwOC0wOC0wNSAyMDowNjowNi4wMDAwMDAwMDAgKzEw
MDAKQEAgLTE1LDYgKzE1LDcgQEAKIAlzZWxlY3QgRFZCX1M1SDE0MDkgaWYg
IURWQl9GRV9DVVNUT01JU0UKIAlzZWxlY3QgRFZCX1M1SDE0MTEgaWYgIURW
Ql9GRV9DVVNUT01JU0UKIAlzZWxlY3QgRFZCX0xHRFQzMzBYIGlmICFEVkJf
RkVfQ1VTVE9NSVNFCisgCXNlbGVjdCBEVkJfWkwxMDM1MyBpZiAhRFZCX0ZF
X0NVU1RPTUlTRQogCXNlbGVjdCBNRURJQV9UVU5FUl9YQzIwMjggaWYgIURW
Ql9GRV9DVVNUT01JWkUKIAlzZWxlY3QgTUVESUFfVFVORVJfVERBODI5MCBp
ZiAhRFZCX0ZFX0NVU1RPTUlaRQogCXNlbGVjdCBNRURJQV9UVU5FUl9UREEx
ODI3MSBpZiAhRFZCX0ZFX0NVU1RPTUlaRQo=

--_----------=_1218332545157091
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1218332545157091--
