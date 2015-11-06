Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33020 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbKFRgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2015 12:36:11 -0500
Received: by pabfh17 with SMTP id fh17so128852645pab.0
        for <linux-media@vger.kernel.org>; Fri, 06 Nov 2015 09:36:10 -0800 (PST)
Message-ID: <1446831368.20743.7.camel@gmail.com>
Subject: Re: PVR-250 Composite 3 unavailable [Re: ivtv driver]
From: Warren Sturm <warren.sturm@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	andy <andy@silverblocksystems.net>
Date: Fri, 06 Nov 2015 10:36:08 -0700
In-Reply-To: <77A58399-549F-4A8A-8F87-8F40B7756D3A@md.metrocast.net>
References: <1445901232.9389.2.camel@gmail.com>
	 <77A58399-549F-4A8A-8F87-8F40B7756D3A@md.metrocast.net>
Content-Type: multipart/mixed; boundary="=-ILKHnyw5Qz79jZapJqQq"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ILKHnyw5Qz79jZapJqQq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2015-10-26 at 19:49 -0400, Andy Walls wrote:
> On October 26, 2015 7:13:52 PM EDT, Warren Sturm <
> warren.sturm@gmail.com> wrote:
> > Hi Andy.
> > 
> > I don't know whether this was intended but the pvr250 lost the
> > composite 3 input when going from kernel version 4.1.10 to 4.2.3.
> > 
> > This is on a Fedora 22 x86_64 system.
> > 
> > 
> > Thanks for any insight.
> 
> Unintentional.
> 
> I'm guessing this commit was the problem:
> 
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/drivers/media/p
> ci/ivtv/ivtv-driver.c?id=09290cc885937cab3b2d60a6d48fe3d2d3e04061
> 
> Could you confirm?
> 
> R,
> Andy

Ok.  I rebuilt the SRPM for kernel-4.2.5-201 with the patch reverted
and installed it.

uname -a
Linux wrs 4.2.5-201.fc22.x86_64 #1 SMP Fri Nov 6 00:13:17 MST 2015 x86_64 x86_64 x86_64 GNU/Linux

Attached are the v4l2-ctl --list-inputs for the respective kernels.

Hope this is sufficient confirmation.




--=-ILKHnyw5Qz79jZapJqQq
Content-Disposition: attachment; filename="pvr250-inputs-kern-4.2.5-post-patch-reversal"
Content-Type: text/plain; name="pvr250-inputs-kern-4.2.5-post-patch-reversal";
	charset="UTF-8"
Content-Transfer-Encoding: base64

aW9jdGw6IFZJRElPQ19FTlVNSU5QVVQKCUlucHV0ICAgOiAwCglOYW1lICAgIDogVHVuZXIgMQoJ
VHlwZSAgICA6IDB4MDAwMDAwMDEKCUF1ZGlvc2V0OiAweDAwMDAwMDA3CglUdW5lciAgIDogMHgw
MDAwMDAwMAoJU3RhbmRhcmQ6IDB4MDAwMDAwMDAwMDAwMTAwMCAoIE5UU0MgKQoJU3RhdHVzICA6
IDAKCglJbnB1dCAgIDogMQoJTmFtZSAgICA6IFMtVmlkZW8gMQoJVHlwZSAgICA6IDB4MDAwMDAw
MDIKCUF1ZGlvc2V0OiAweDAwMDAwMDA3CglUdW5lciAgIDogMHgwMDAwMDAwMAoJU3RhbmRhcmQ6
IDB4MDAwMDAwMDAwMEZGRkZGRiAoIFBBTCBOVFNDIFNFQ0FNICkKCVN0YXR1cyAgOiAwCgoJSW5w
dXQgICA6IDIKCU5hbWUgICAgOiBDb21wb3NpdGUgMQoJVHlwZSAgICA6IDB4MDAwMDAwMDIKCUF1
ZGlvc2V0OiAweDAwMDAwMDA3CglUdW5lciAgIDogMHgwMDAwMDAwMAoJU3RhbmRhcmQ6IDB4MDAw
MDAwMDAwMEZGRkZGRiAoIFBBTCBOVFNDIFNFQ0FNICkKCVN0YXR1cyAgOiAwCgoJSW5wdXQgICA6
IDMKCU5hbWUgICAgOiBTLVZpZGVvIDIKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDog
MHgwMDAwMDAwNwoJVHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBG
RkZGRkYgKCBQQUwgTlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAoKCUlucHV0ICAgOiA0CglOYW1l
ICAgIDogQ29tcG9zaXRlIDIKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDogMHgwMDAw
MDAwNwoJVHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBGRkZGRkYg
KCBQQUwgTlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAoKCUlucHV0ICAgOiA1CglOYW1lICAgIDog
Q29tcG9zaXRlIDMKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDogMHgwMDAwMDAwNwoJ
VHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBGRkZGRkYgKCBQQUwg
TlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAo=


--=-ILKHnyw5Qz79jZapJqQq
Content-Disposition: attachment; filename="pvr250-inputs-kern-4.2.5"
Content-Type: text/plain; name="pvr250-inputs-kern-4.2.5"; charset="UTF-8"
Content-Transfer-Encoding: base64

aW9jdGw6IFZJRElPQ19FTlVNSU5QVVQKCUlucHV0ICAgOiAwCglOYW1lICAgIDogVHVuZXIgMQoJ
VHlwZSAgICA6IDB4MDAwMDAwMDEKCUF1ZGlvc2V0OiAweDAwMDAwMDAzCglUdW5lciAgIDogMHgw
MDAwMDAwMAoJU3RhbmRhcmQ6IDB4MDAwMDAwMDAwMDAwMTAwMCAoIE5UU0MgKQoJU3RhdHVzICA6
IDAKCglJbnB1dCAgIDogMQoJTmFtZSAgICA6IFMtVmlkZW8gMQoJVHlwZSAgICA6IDB4MDAwMDAw
MDIKCUF1ZGlvc2V0OiAweDAwMDAwMDAzCglUdW5lciAgIDogMHgwMDAwMDAwMAoJU3RhbmRhcmQ6
IDB4MDAwMDAwMDAwMEZGRkZGRiAoIFBBTCBOVFNDIFNFQ0FNICkKCVN0YXR1cyAgOiAwCgoJSW5w
dXQgICA6IDIKCU5hbWUgICAgOiBDb21wb3NpdGUgMQoJVHlwZSAgICA6IDB4MDAwMDAwMDIKCUF1
ZGlvc2V0OiAweDAwMDAwMDAzCglUdW5lciAgIDogMHgwMDAwMDAwMAoJU3RhbmRhcmQ6IDB4MDAw
MDAwMDAwMEZGRkZGRiAoIFBBTCBOVFNDIFNFQ0FNICkKCVN0YXR1cyAgOiAwCgoJSW5wdXQgICA6
IDMKCU5hbWUgICAgOiBTLVZpZGVvIDIKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDog
MHgwMDAwMDAwMwoJVHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBG
RkZGRkYgKCBQQUwgTlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAoKCUlucHV0ICAgOiA0CglOYW1l
ICAgIDogQ29tcG9zaXRlIDIKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDogMHgwMDAw
MDAwMwoJVHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBGRkZGRkYg
KCBQQUwgTlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAo=


--=-ILKHnyw5Qz79jZapJqQq
Content-Disposition: attachment; filename="pvr250-inputs-kern-4.1.10"
Content-Type: text/plain; name="pvr250-inputs-kern-4.1.10"; charset="UTF-8"
Content-Transfer-Encoding: base64

aW9jdGw6IFZJRElPQ19FTlVNSU5QVVQKCUlucHV0ICAgOiAwCglOYW1lICAgIDogVHVuZXIgMQoJ
VHlwZSAgICA6IDB4MDAwMDAwMDEKCUF1ZGlvc2V0OiAweDAwMDAwMDA3CglUdW5lciAgIDogMHgw
MDAwMDAwMAoJU3RhbmRhcmQ6IDB4MDAwMDAwMDAwMDAwMTAwMCAoIE5UU0MgKQoJU3RhdHVzICA6
IDAKCglJbnB1dCAgIDogMQoJTmFtZSAgICA6IFMtVmlkZW8gMQoJVHlwZSAgICA6IDB4MDAwMDAw
MDIKCUF1ZGlvc2V0OiAweDAwMDAwMDA3CglUdW5lciAgIDogMHgwMDAwMDAwMAoJU3RhbmRhcmQ6
IDB4MDAwMDAwMDAwMEZGRkZGRiAoIFBBTCBOVFNDIFNFQ0FNICkKCVN0YXR1cyAgOiAwCgoJSW5w
dXQgICA6IDIKCU5hbWUgICAgOiBDb21wb3NpdGUgMQoJVHlwZSAgICA6IDB4MDAwMDAwMDIKCUF1
ZGlvc2V0OiAweDAwMDAwMDA3CglUdW5lciAgIDogMHgwMDAwMDAwMAoJU3RhbmRhcmQ6IDB4MDAw
MDAwMDAwMEZGRkZGRiAoIFBBTCBOVFNDIFNFQ0FNICkKCVN0YXR1cyAgOiAwCgoJSW5wdXQgICA6
IDMKCU5hbWUgICAgOiBTLVZpZGVvIDIKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDog
MHgwMDAwMDAwNwoJVHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBG
RkZGRkYgKCBQQUwgTlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAoKCUlucHV0ICAgOiA0CglOYW1l
ICAgIDogQ29tcG9zaXRlIDIKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDogMHgwMDAw
MDAwNwoJVHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBGRkZGRkYg
KCBQQUwgTlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAoKCUlucHV0ICAgOiA1CglOYW1lICAgIDog
Q29tcG9zaXRlIDMKCVR5cGUgICAgOiAweDAwMDAwMDAyCglBdWRpb3NldDogMHgwMDAwMDAwNwoJ
VHVuZXIgICA6IDB4MDAwMDAwMDAKCVN0YW5kYXJkOiAweDAwMDAwMDAwMDBGRkZGRkYgKCBQQUwg
TlRTQyBTRUNBTSApCglTdGF0dXMgIDogMAo=


--=-ILKHnyw5Qz79jZapJqQq--

