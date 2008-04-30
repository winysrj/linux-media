Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ttmails2@gmx.de>) id 1JrBkA-0007R5-Hj
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 14:49:09 +0200
Message-ID: <48186AA2.5090807@gmx.de>
Date: Wed, 30 Apr 2008 14:48:34 +0200
From: ttmails2@gmx.de
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48185BE7.6070309@gmx.de>
	<37219a840804300543y62bbcdf2w50ceeba7aeed8ed2@mail.gmail.com>
In-Reply-To: <37219a840804300543y62bbcdf2w50ceeba7aeed8ed2@mail.gmail.com>
Subject: Re: [linux-dvb] compile error with 2.6.25
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks, rolling back to changeset 7794:51c8465ecc72 works for me!

Michael Krufky wrote:
> On Wed, Apr 30, 2008 at 7:45 AM,  <ttmails2@gmx.de> wrote:
>> Hello,
>>
>>  I have a strange compile error with kernel 2.6.25. I already searched
>>  through the web but couldn't find anything.
>>
>>  tim@notebook ~/v4l-dvb $ make
>>  make -C /home/tim/v4l-dvb/v4l
>>  make[1]: Entering directory `/home/tim/v4l-dvb/v4l'
>>  No version yet, using 2.6.25
>>  make[1]: Leaving directory `/home/tim/v4l-dvb/v4l'
>>  make[1]: Entering directory `/home/tim/v4l-dvb/v4l'
>>  scripts/make_makefile.pl
>>  Updating/Creating .config
>>  Preparing to compile for kernel version 2.6.25
>>  File not found: ../linux/drivers/media/common/Kconfig at
>>  ./scripts/make_kconfig.pl line 281, <GEN2> line 97.
>>  make[1]: Leaving directory `/home/tim/v4l-dvb/v4l'
>>  make[1]: Entering directory `/home/tim/v4l-dvb/v4l'
>>  Updating/Creating .config
>>  Preparing to compile for kernel version 2.6.25
>>  File not found: ../linux/drivers/media/common/Kconfig at
>>  ./scripts/make_kconfig.pl line 281, <GEN2> line 97.
>>  make[1]: *** No rule to make target `.myconfig', needed by
>>  `config-compat.h'.  Stop.
>>  make[1]: Leaving directory `/home/tim/v4l-dvb/v4l'
>>  make: *** [all] Error 2
> 
> The master branch is currently broken.  In backporting some changes
> from -git, it appears that Mauro had forgotten to "hg add" a Kconfig
> file.  I've cc'd him to this email, and hopefully he'll fix the
> problem soon.  In the meanwhile, you can roll back to the commit
> before the breakage:
> 
> changeset:   7794:51c8465ecc72
> 
> To do this, you can clone a fresh tree at that revision:
> 
> hg clone -r 51c8465ecc72 {source tree} {destination tree}
> 
> ...There are some other ways to do this as well ... this is the easiest.
> 
> I hope this helps,
> 
> Mike
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
