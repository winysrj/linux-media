Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:48997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZCGBz3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 20:55:29 -0500
Date: Sat, 7 Mar 2009 02:55:06 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	"Hans J. Koch" <hjk@linutronix.de>,
	hermann pitton <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and RDS
Message-ID: <20090307015506.GC3058@local>
References: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl> <200903051736.44582.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903051736.44582.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 05, 2009 at 05:36:44PM +0100, Hans Verkuil wrote:
> On Thursday 05 March 2009 13:07:10 Hans Verkuil wrote:
> > > Hi Hans
> > >
> > > I build fresh video4linux with your patch and my config for our cards.
> > > In a dmesg i see : found RDS decoder.
> > > cat /dev/radio0 give me some slow junk data. Is this RDS data??
> > > Have you any tools for testing RDS?
> > > I try build rdsd from Hans J. Koch, but build crashed with:
> > >
> > > rdshandler.cpp: In member function âvoid
> > > std::RDShandler::delete_client(std::RDSclient*)â:
> > > rdshandler.cpp:363: error: no matching function for call to
> > > âfind(__gnu_cxx::__normal_iterator<std::RDSclient**,
> > > std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> > > __gnu_cxx::__normal_iterator<std::RDSclient**,
> > > std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> > > std::RDSclient*&)â
> >
> > Ah yes, that's right. I had to hack the C++ source to make this compile.
> > I'll see if I can post a patch for this tonight.
> 
> Attached is the diff that makes rdsd compile on my system.

Great, thanks! The problem is, I really haven't got the time for RDS anymore.
I simply cannot test your patch and check it in. From your previous
contributions I know you as a competent and trustworthy v4l developer and
would give you write access to the repository. Interested?

Thanks,
Hans, too :)

> 
> Regards,
> 
> 	Hans
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

> diff -ur rdsd-0.0.1/src/rdsclient.cpp tmp/rdsd-0.0.1/src/rdsclient.cpp
> --- rdsd-0.0.1/src/rdsclient.cpp	2009-02-10 23:07:02.000000000 +0100
> +++ tmp/rdsd-0.0.1/src/rdsclient.cpp	2005-12-29 18:01:12.000000000 +0100
> @@ -18,7 +18,6 @@
>   *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
>   ***************************************************************************/
>  #include "rdsclient.h"
> -#include <stdlib.h>
>  #include <sstream>
>  
>  namespace std {
> diff -ur rdsd-0.0.1/src/rdsd.cpp tmp/rdsd-0.0.1/src/rdsd.cpp
> --- rdsd-0.0.1/src/rdsd.cpp	2009-02-10 23:05:29.000000000 +0100
> +++ tmp/rdsd-0.0.1/src/rdsd.cpp	2005-12-29 11:51:42.000000000 +0100
> @@ -26,8 +26,7 @@
>  #include "rdshandler.h"
>  #include <csignal>
>  #include <fcntl.h>
> -#include <string.h>
> -#include <stdlib.h>
> +#include <string>
>  #include <sstream>
>  
>  using namespace std;
> diff -ur rdsd-0.0.1/src/rdshandler.cpp tmp/rdsd-0.0.1/src/rdshandler.cpp
> --- rdsd-0.0.1/src/rdshandler.cpp	2009-02-10 23:06:18.000000000 +0100
> +++ tmp/rdsd-0.0.1/src/rdshandler.cpp	2005-12-29 11:52:40.000000000 +0100
> @@ -25,7 +25,6 @@
>  #include <unistd.h>
>  #include <fcntl.h>
>  #include <sstream>
> -#include <algorithm>
>  
>  namespace std {
>  
> @@ -355,7 +354,7 @@
>        FD_CLR(fd,&all_fds);
>        cli->Close();
>      }
> -    RDSclientList::iterator it = std::find(clientlist.begin(),clientlist.end(),cli);
> +    RDSclientList::iterator it = find(clientlist.begin(),clientlist.end(),cli);
>      if (it != clientlist.end()) clientlist.erase(it);
>      delete cli;
>      calc_maxfd();
> diff -ur rdsd-0.0.1/src/rdssource.cpp tmp/rdsd-0.0.1/src/rdssource.cpp
> --- rdsd-0.0.1/src/rdssource.cpp	2009-02-10 23:06:39.000000000 +0100
> +++ tmp/rdsd-0.0.1/src/rdssource.cpp	2005-12-29 18:03:56.000000000 +0100
> @@ -26,7 +26,6 @@
>  #include <linux/videodev.h>
>  #include <linux/videodev2.h>
>  //#include <linux/i2c.h> //lots of errors if I include this...
> -#include <string.h>
>  #include <sstream>
>  
>  namespace std {

