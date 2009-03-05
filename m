Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1433 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZCEQgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 11:36:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dmitri Belimov" <d.belimov@gmail.com>
Subject: Re: saa7134 and RDS
Date: Thu, 5 Mar 2009 17:36:44 +0100
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	"hermann pitton" <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
References: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl>
In-Reply-To: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_c+/rJYmVjZ41y5R"
Message-Id: <200903051736.44582.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_c+/rJYmVjZ41y5R
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 05 March 2009 13:07:10 Hans Verkuil wrote:
> > Hi Hans
> >
> > I build fresh video4linux with your patch and my config for our cards.
> > In a dmesg i see : found RDS decoder.
> > cat /dev/radio0 give me some slow junk data. Is this RDS data??
> > Have you any tools for testing RDS?
> > I try build rdsd from Hans J. Koch, but build crashed with:
> >
> > rdshandler.cpp: In member function =E2=80=98void
> > std::RDShandler::delete_client(std::RDSclient*)=E2=80=99:
> > rdshandler.cpp:363: error: no matching function for call to
> > =E2=80=98find(__gnu_cxx::__normal_iterator<std::RDSclient**,
> > std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> > __gnu_cxx::__normal_iterator<std::RDSclient**,
> > std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> > std::RDSclient*&)=E2=80=99
>
> Ah yes, that's right. I had to hack the C++ source to make this compile.
> I'll see if I can post a patch for this tonight.

Attached is the diff that makes rdsd compile on my system.

Regards,

	Hans


=2D-=20
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--Boundary-00=_c+/rJYmVjZ41y5R
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="rdsd.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rdsd.diff"

diff -ur rdsd-0.0.1/src/rdsclient.cpp tmp/rdsd-0.0.1/src/rdsclient.cpp
--- rdsd-0.0.1/src/rdsclient.cpp	2009-02-10 23:07:02.000000000 +0100
+++ tmp/rdsd-0.0.1/src/rdsclient.cpp	2005-12-29 18:01:12.000000000 +0100
@@ -18,7 +18,6 @@
  *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 #include "rdsclient.h"
-#include <stdlib.h>
 #include <sstream>
 
 namespace std {
diff -ur rdsd-0.0.1/src/rdsd.cpp tmp/rdsd-0.0.1/src/rdsd.cpp
--- rdsd-0.0.1/src/rdsd.cpp	2009-02-10 23:05:29.000000000 +0100
+++ tmp/rdsd-0.0.1/src/rdsd.cpp	2005-12-29 11:51:42.000000000 +0100
@@ -26,8 +26,7 @@
 #include "rdshandler.h"
 #include <csignal>
 #include <fcntl.h>
-#include <string.h>
-#include <stdlib.h>
+#include <string>
 #include <sstream>
 
 using namespace std;
diff -ur rdsd-0.0.1/src/rdshandler.cpp tmp/rdsd-0.0.1/src/rdshandler.cpp
--- rdsd-0.0.1/src/rdshandler.cpp	2009-02-10 23:06:18.000000000 +0100
+++ tmp/rdsd-0.0.1/src/rdshandler.cpp	2005-12-29 11:52:40.000000000 +0100
@@ -25,7 +25,6 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <sstream>
-#include <algorithm>
 
 namespace std {
 
@@ -355,7 +354,7 @@
       FD_CLR(fd,&all_fds);
       cli->Close();
     }
-    RDSclientList::iterator it = std::find(clientlist.begin(),clientlist.end(),cli);
+    RDSclientList::iterator it = find(clientlist.begin(),clientlist.end(),cli);
     if (it != clientlist.end()) clientlist.erase(it);
     delete cli;
     calc_maxfd();
diff -ur rdsd-0.0.1/src/rdssource.cpp tmp/rdsd-0.0.1/src/rdssource.cpp
--- rdsd-0.0.1/src/rdssource.cpp	2009-02-10 23:06:39.000000000 +0100
+++ tmp/rdsd-0.0.1/src/rdssource.cpp	2005-12-29 18:03:56.000000000 +0100
@@ -26,7 +26,6 @@
 #include <linux/videodev.h>
 #include <linux/videodev2.h>
 //#include <linux/i2c.h> //lots of errors if I include this...
-#include <string.h>
 #include <sstream>
 
 namespace std {

--Boundary-00=_c+/rJYmVjZ41y5R--
