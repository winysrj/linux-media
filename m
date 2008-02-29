Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JV8We-0001LE-6K
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 17:56:00 +0100
Message-ID: <47C83919.4010102@powercraft.nl>
Date: Fri, 29 Feb 2008 17:55:53 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>, em28xx@mcentral.de,
	linux-dvb <linux-dvb@linuxtv.org>
References: <47C83611.1040805@powercraft.nl>
	<d9def9db0802290848v100ca9dcm22292e368bec4ad5@mail.gmail.com>
In-Reply-To: <d9def9db0802290848v100ca9dcm22292e368bec4ad5@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------050505000503000401010904"
Subject: Re: [linux-dvb] Pinnacle PCTV Hybrid Pro Stick 330e - Installation
 Guide - v0.1.2j
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
--------------050505000503000401010904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Markus Rechberger wrote:
> Hi Jelle,
> 
> On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>> This message contains the following attachment(s):
>> Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
>>
> 
> the correct mailinglist for those devices is em28xx at mcentral dot de
> 
> I added some comments below and prefixed them with /////////
> 
> This message contains the following attachment(s):
>  Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
> 

We will get it working in the next few days, i am already working on a 
user guide. I will add the comments to the new version, i just thought 
release as soon as possible, dont want somebody else to spent hours and 
hours of his day installing your nice driver.

Nice, I was working on building tvtime but it gave me errors,

# remove orignal application
sudo apt-get remove tvtime

# install necessary tools
sudo apt-get install build-essential mercurial

cd ~
sudo rm -r tvtime
hg clone http://mcentral.de/hg/~mrec/tvtime
cd tvtime
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
cd ~




--------------050505000503000401010904
Content-Type: text/plain;
 name="error-log-tvtime-number-1.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="error-log-tvtime-number-1.txt"

jelle@xubutu-en12000e:~$ # remove orignal application
jelle@xubutu-en12000e:~$ sudo apt-get remove tvtime
[sudo] password for jelle:
Reading package lists... Done
Building dependency tree
Reading state information... Done
Package tvtime is not installed, so not removed
The following packages were automatically installed and are no longer required:
  nvidia-kernel-common
Use 'apt-get autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
jelle@xubutu-en12000e:~$ # remove orignal application
jelle@xubutu-en12000e:~$ sudo apt-get remove tvtime
Reading package lists... Done
Building dependency tree
Reading state information... Done
Package tvtime is not installed, so not removed
The following packages were automatically installed and are no longer required:
  nvidia-kernel-common
Use 'apt-get autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
jelle@xubutu-en12000e:~$
jelle@xubutu-en12000e:~$ # install necessary tools
jelle@xubutu-en12000e:~$ sudo apt-get install build-essential mercurial
Reading package lists... Done
Building dependency tree
Reading state information... Done
build-essential is already the newest version.
mercurial is already the newest version.
The following packages were automatically installed and are no longer required:
  nvidia-kernel-common
Use 'apt-get autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
jelle@xubutu-en12000e:~$
jelle@xubutu-en12000e:~$ cd ~
jelle@xubutu-en12000e:~$ sudo rm -r tvtime
jelle@xubutu-en12000e:~$ hg clone http://mcentral.de/hg/~mrec/tvtime
destination directory: tvtime
requesting all changes
adding changesets
adding manifests
adding file changes
added 2 changesets with 376 changes to 375 files
375 files updated, 0 files merged, 0 files removed, 0 files unresolved
jelle@xubutu-en12000e:~$ cd tvtime
jelle@xubutu-en12000e:~/tvtime$ ./configure --prefix=/usr --sysconfdir=/etc
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether to enable maintainer-specific portions of Makefiles... no
checking build system type... i686-pc-linux-gnu
checking host system type... i686-pc-linux-gnu
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables...
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ANSI C... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking for gcc... yes
checking for g++... g++
checking whether we are using the GNU C++ compiler... yes
checking whether g++ accepts -g... yes
checking dependency style of g++... gcc3
checking for g++... yes
checking for a sed that does not truncate output... /bin/sed
checking for egrep... grep -E
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for /usr/bin/ld option to reload object files... -r
checking for BSD-compatible nm... /usr/bin/nm -B
checking whether ln -s works... yes
checking how to recognise dependent libraries... pass_all
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking dlfcn.h usability... yes
checking dlfcn.h presence... yes
checking for dlfcn.h... yes
checking how to run the C++ preprocessor... g++ -E
checking for g77... no
checking for f77... no
checking for xlf... no
checking for frt... no
checking for pgf77... no
checking for fort77... no
checking for fl32... no
checking for af77... no
checking for f90... no
checking for xlf90... no
checking for pgf90... no
checking for epcf90... no
checking for f95... no
checking for fort... no
checking for xlf95... no
checking for ifc... no
checking for efc... no
checking for pgf95... no
checking for lf95... no
checking for gfortran... no
checking whether we are using the GNU Fortran 77 compiler... no
checking whether  accepts -g... no
checking the maximum length of command line arguments... 32768
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for objdir... .libs
checking for ar... ar
checking for ranlib... ranlib
checking for strip... strip
checking if gcc static flag  works... yes
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC
checking if gcc PIC flag -fPIC works... yes
checking if gcc supports -c -o file.o... yes
checking whether the gcc linker (/usr/bin/ld) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
configure: creating libtool
appending configuration tag "CXX" to libtool
checking for ld used by g++... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking whether the g++ linker (/usr/bin/ld) supports shared libraries... yes
checking for g++ option to produce PIC... -fPIC
checking if g++ PIC flag -fPIC works... yes
checking if g++ supports -c -o file.o... yes
checking whether the g++ linker (/usr/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
appending configuration tag "F77" to libtool
checking for ANSI C header files... (cached) yes
checking ctype.h usability... yes
checking ctype.h presence... yes
checking for ctype.h... yes
checking dirent.h usability... yes
checking dirent.h presence... yes
checking for dirent.h... yes
checking errno.h usability... yes
checking errno.h presence... yes
checking for errno.h... yes
checking fcntl.h usability... yes
checking fcntl.h presence... yes
checking for fcntl.h... yes
checking getopt.h usability... yes
checking getopt.h presence... yes
checking for getopt.h... yes
checking langinfo.h usability... yes
checking langinfo.h presence... yes
checking for langinfo.h... yes
checking math.h usability... yes
checking math.h presence... yes
checking for math.h... yes
checking netinet/in.h usability... yes
checking netinet/in.h presence... yes
checking for netinet/in.h... yes
checking pwd.h usability... yes
checking pwd.h presence... yes
checking for pwd.h... yes
checking signal.h usability... yes
checking signal.h presence... yes
checking for signal.h... yes
checking for stdint.h... (cached) yes
checking stdio.h usability... yes
checking stdio.h presence... yes
checking for stdio.h... yes
checking for stdlib.h... (cached) yes
checking for string.h... (cached) yes
checking sys/ioctl.h usability... yes
checking sys/ioctl.h presence... yes
checking for sys/ioctl.h... yes
checking sys/mman.h usability... yes
checking sys/mman.h presence... yes
checking for sys/mman.h... yes
checking sys/resource.h usability... yes
checking sys/resource.h presence... yes
checking for sys/resource.h... yes
checking for sys/stat.h... (cached) yes
checking sys/time.h usability... yes
checking sys/time.h presence... yes
checking for sys/time.h... yes
checking sys/wait.h usability... yes
checking sys/wait.h presence... yes
checking for sys/wait.h... yes
checking for sys/types.h... (cached) yes
checking for unistd.h... (cached) yes
checking wordexp.h usability... yes
checking wordexp.h presence... yes
checking for wordexp.h... yes
checking locale.h usability... yes
checking locale.h presence... yes
checking for locale.h... yes
checking whether time.h and sys/time.h may both be included... yes
checking whether gcc needs -traditional... no
checking for stdlib.h... (cached) yes
checking for unistd.h... (cached) yes
checking for getpagesize... yes
checking for working mmap... yes
checking for asprintf... yes
checking for atexit... yes
checking for fork... yes
checking for execlp... yes
checking for getopt_long... yes
checking for getpriority... yes
checking for gettimeofday... yes
checking for seteuid... yes
checking for memset... yes
checking for setreuid... yes
checking for setpriority... yes
checking for signal... yes
checking for sigemptyset... yes
checking for sigaction... yes
checking for strerror... yes
checking for vsscanf... yes
checking for wordexp... yes
checking for wordfree... yes
checking whether NLS is requested... yes
checking for msgfmt... /usr/bin/msgfmt
checking for gmsgfmt... /usr/bin/msgfmt
checking for xgettext... /usr/bin/xgettext
checking for msgmerge... /usr/bin/msgmerge
checking for ranlib... (cached) ranlib
checking for strerror in -lcposix... no
checking for an ANSI C-conforming const... yes
checking for inline... inline
checking for off_t... yes
checking for size_t... yes
checking for working alloca.h... yes
checking for alloca... yes
checking whether we are using the GNU C Library 2.1 or newer... yes
checking whether integer division by zero raises SIGFPE... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unsigned long long... yes
checking for inttypes.h... yes
checking whether the inttypes.h PRIxNN macros are broken... no
checking for ld used by GCC... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for shared library run path origin... done
checking argz.h usability... yes
checking argz.h presence... yes
checking for argz.h... yes
checking limits.h usability... yes
checking limits.h presence... yes
checking for limits.h... yes
checking for locale.h... (cached) yes
checking nl_types.h usability... yes
checking nl_types.h presence... yes
checking for nl_types.h... yes
checking malloc.h usability... yes
checking malloc.h presence... yes
checking for malloc.h... yes
checking stddef.h usability... yes
checking stddef.h presence... yes
checking for stddef.h... yes
checking for stdlib.h... (cached) yes
checking for string.h... (cached) yes
checking for unistd.h... (cached) yes
checking sys/param.h usability... yes
checking sys/param.h presence... yes
checking for sys/param.h... yes
checking for feof_unlocked... yes
checking for fgets_unlocked... yes
checking for getc_unlocked... yes
checking for getcwd... yes
checking for getegid... yes
checking for geteuid... yes
checking for getgid... yes
checking for getuid... yes
checking for mempcpy... yes
checking for munmap... yes
checking for putenv... yes
checking for setenv... yes
checking for setlocale... yes
checking for stpcpy... yes
checking for strcasecmp... yes
checking for strdup... yes
checking for strtoul... yes
checking for tsearch... yes
checking for __argz_count... yes
checking for __argz_stringify... yes
checking for __argz_next... yes
checking for __fsetlocking... yes
checking for iconv... yes
checking for iconv declaration...
         extern size_t iconv (iconv_t cd, char * *inbuf, size_t *inbytesleft, char * *outbuf, size_t *outbytesleft);
checking for nl_langinfo and CODESET... yes
checking for LC_MESSAGES... yes
checking for bison... no
checking whether NLS is requested... yes
checking whether included gettext is requested... no
checking for GNU gettext in libc... yes
checking whether to use NLS... yes
checking where the gettext function comes from... libc
checking for gzsetparams in -lz... yes
checking zlib.h usability... yes
checking zlib.h presence... yes
checking for zlib.h... yes
checking for png_read_png in -lpng... yes
checking png.h usability... yes
checking png.h presence... yes
checking for png.h... yes
checking for freetype-config... /usr/bin/freetype-config
checking for xml2-config... /usr/bin/xml2-config
checking for X... libraries , headers in standard search path
checking for gethostbyname... yes
checking for connect... yes
checking for remove... yes
checking for shmat... yes
checking for IceConnectionNumber in -lICE... yes
checking for XShmCreateImage in -lXext... yes
checking for XvShmCreateImage in -lXv... yes
checking for XineramaQueryScreens in -lXinerama... yes
checking for XTestFakeKeyEvent in -lXtst... yes
checking for XF86VidModeGetModeLine in -lXxf86vm... yes
checking if gcc supports -g  -O3 flags... yes
checking if gcc supports -g  -O3 -fomit-frame-pointer flags... yes
checking if gcc supports -g  -O3 -fomit-frame-pointer -std=gnu99 flags... yes
checking if gcc supports -g  -O3 -fomit-frame-pointer -std=gnu99 flags... yes
checking for memalign... yes
checking return type of signal handlers... void
checking for an ANSI C-conforming const... (cached) yes
checking for inline... (cached) inline
checking for size_t... (cached) yes
checking whether byte ordering is bigendian... no
checking __attribute__ ((aligned ())) support... 64
configure: creating ./config.status
config.status: creating Makefile
config.status: creating docs/Makefile
config.status: creating data/Makefile
config.status: creating plugins/Makefile
config.status: creating src/Makefile
config.status: creating intl/Makefile
config.status: creating po/Makefile.in
config.status: creating m4/Makefile
config.status: creating docs/man/Makefile
config.status: creating docs/man/de/Makefile
config.status: creating docs/man/en/Makefile
config.status: creating docs/man/es/Makefile
config.status: creating config.h
config.status: executing depfiles commands
config.status: executing default-1 commands
config.status: creating po/POTFILES
config.status: creating po/Makefile
jelle@xubutu-en12000e:~/tvtime$ make
make  all-recursive
make[1]: Entering directory `/home/jelle/tvtime'
Making all in intl
make[2]: Entering directory `/home/jelle/tvtime/intl'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/jelle/tvtime/intl'
Making all in m4
make[2]: Entering directory `/home/jelle/tvtime/m4'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/jelle/tvtime/m4'
Making all in docs
make[2]: Entering directory `/home/jelle/tvtime/docs'
Making all in man
make[3]: Entering directory `/home/jelle/tvtime/docs/man'
Making all in de
make[4]: Entering directory `/home/jelle/tvtime/docs/man/de'
make[4]: Nothing to be done for `all'.
make[4]: Leaving directory `/home/jelle/tvtime/docs/man/de'
Making all in en
make[4]: Entering directory `/home/jelle/tvtime/docs/man/en'
make[4]: Nothing to be done for `all'.
make[4]: Leaving directory `/home/jelle/tvtime/docs/man/en'
Making all in es
make[4]: Entering directory `/home/jelle/tvtime/docs/man/es'
make[4]: Nothing to be done for `all'.
make[4]: Leaving directory `/home/jelle/tvtime/docs/man/es'
make[4]: Entering directory `/home/jelle/tvtime/docs/man'
make[4]: Nothing to be done for `all-am'.
make[4]: Leaving directory `/home/jelle/tvtime/docs/man'
make[3]: Leaving directory `/home/jelle/tvtime/docs/man'
make[3]: Entering directory `/home/jelle/tvtime/docs'
make[3]: Nothing to be done for `all-am'.
make[3]: Leaving directory `/home/jelle/tvtime/docs'
make[2]: Leaving directory `/home/jelle/tvtime/docs'
Making all in data
make[2]: Entering directory `/home/jelle/tvtime/data'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/jelle/tvtime/data'
Making all in plugins
make[2]: Entering directory `/home/jelle/tvtime/plugins'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/jelle/tvtime/plugins'
Making all in src
make[2]: Entering directory `/home/jelle/tvtime/src'
if gcc -DHAVE_CONFIG_H -I. -I. -I..    `/usr/bin/freetype-config --cflags`  -Wall -pedantic -I. -DDATADIR="\"/usr/share/tvtime\"" -DCONFDIR="\"/etc/tvtime\"" -DFIFODIR="\"/tmp\"" -D_LARGEFILE64_SOURCE -DLOCALEDIR="\"/usr/share/locale\"" -I../plugins  -I/usr/include/libxml2   -g  -O3 -fomit-frame-pointer -std=gnu99 -MT tvtime-mixer.o -MD -MP -MF ".deps/tvtime-mixer.Tpo" \
          -c -o tvtime-mixer.o `test -f 'mixer.c' || echo './'`mixer.c; \
        then mv -f ".deps/tvtime-mixer.Tpo" ".deps/tvtime-mixer.Po"; \
        else rm -f ".deps/tvtime-mixer.Tpo"; exit 1; \
        fi
if gcc -DHAVE_CONFIG_H -I. -I. -I..    `/usr/bin/freetype-config --cflags`  -Wall -pedantic -I. -DDATADIR="\"/usr/share/tvtime\"" -DCONFDIR="\"/etc/tvtime\"" -DFIFODIR="\"/tmp\"" -D_LARGEFILE64_SOURCE -DLOCALEDIR="\"/usr/share/locale\"" -I../plugins  -I/usr/include/libxml2   -g  -O3 -fomit-frame-pointer -std=gnu99 -MT tvtime-videoinput.o -MD -MP -MF ".deps/tvtime-videoinput.Tpo" \
          -c -o tvtime-videoinput.o `test -f 'videoinput.c' || echo './'`videoinput.c; \
        then mv -f ".deps/tvtime-videoinput.Tpo" ".deps/tvtime-videoinput.Po"; \
        else rm -f ".deps/tvtime-videoinput.Tpo"; exit 1; \
        fi
In file included from videoinput.c:39:
videodev2.h:19:46: error: linux/compiler.h: No such file or directory
In file included from videoinput.c:42:
tvaudio.h:3:28: error: alsa/asoundlib.h: No such file or directory
In file included from videoinput.c:42:
tvaudio.h:7: error: expected specifier-qualifier-list before ‘snd_pcm_t’
videoinput.c: In function ‘videoinput_new’:
videoinput.c:489: error: ‘struct tvaudio’ has no member named ‘state’
make[2]: *** [tvtime-videoinput.o] Error 1
make[2]: Leaving directory `/home/jelle/tvtime/src'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/jelle/tvtime'
make: *** [all] Error 2
jelle@xubutu-en12000e:~/tvtime$ sudo make install
Making install in intl
make[1]: Entering directory `/home/jelle/tvtime/intl'
if { test "tvtime" = "gettext-runtime" || test "tvtime" = "gettext-tools"; } \
           && test 'no' = yes; then \
          /bin/sh .././mkinstalldirs /usr/lib /usr/include; \
          /usr/bin/install -c -m 644 libintl.h /usr/include/libintl.h; \
          /bin/sh ../libtool --mode=install \
            /usr/bin/install -c -m 644 libintl.a /usr/lib/libintl.a; \
          if test "@RELOCATABLE@" = yes; then \
            dependencies=`sed -n -e 's,^dependency_libs=\(.*\),\1,p' < /usr/lib/libintl.la | sed -e "s,^',," -e "s,'\$,,"`; \
            if test -n "ependencies"; then \
              rm -f /usr/lib/libintl.la; \
            fi; \
          fi; \
        else \
          : ; \
        fi
if test "tvtime" = "gettext-tools" \
           && test 'no' = no; then \
          /bin/sh .././mkinstalldirs /usr/lib; \
          /bin/sh ../libtool --mode=install \
            /usr/bin/install -c -m 644 libgnuintl.a /usr/lib/libgnuintl.a; \
          rm -f /usr/lib/preloadable_libintl.so; \
          /usr/bin/install -c -m 644 /usr/lib/libgnuintl.so /usr/lib/preloadable_libintl.so; \
          /bin/sh ../libtool --mode=uninstall \
            rm -f /usr/lib/libgnuintl.a; \
        else \
          : ; \
        fi
if test 'no' = yes; then \
          test yes != no || /bin/sh .././mkinstalldirs /usr/lib; \
          temp=/usr/lib/t-charset.alias; \
          dest=/usr/lib/charset.alias; \
          if test -f /usr/lib/charset.alias; then \
            orig=/usr/lib/charset.alias; \
            sed -f ref-add.sed $orig > $temp; \
            /usr/bin/install -c -m 644 $temp $dest; \
            rm -f $temp; \
          else \
            if test yes = no; then \
              orig=charset.alias; \
              sed -f ref-add.sed $orig > $temp; \
              /usr/bin/install -c -m 644 $temp $dest; \
              rm -f $temp; \
            fi; \
          fi; \
          /bin/sh .././mkinstalldirs /usr/share/locale; \
          test -f /usr/share/locale/locale.alias \
            && orig=/usr/share/locale/locale.alias \
            || orig=./locale.alias; \
          temp=/usr/share/locale/t-locale.alias; \
          dest=/usr/share/locale/locale.alias; \
          sed -f ref-add.sed $orig > $temp; \
          /usr/bin/install -c -m 644 $temp $dest; \
          rm -f $temp; \
        else \
          : ; \
        fi
if test "tvtime" = "gettext-tools"; then \
          /bin/sh .././mkinstalldirs /usr/share/gettext/intl; \
          /usr/bin/install -c -m 644 VERSION /usr/share/gettext/intl/VERSION; \
          /usr/bin/install -c -m 644 ChangeLog.inst /usr/share/gettext/intl/ChangeLog; \
          dists="COPYING.LIB-2.0 COPYING.LIB-2.1 Makefile.in config.charset locale.alias ref-add.sin ref-del.sin gmo.h gettextP.h hash-string.h loadinfo.h plural-exp.h eval-plural.h localcharset.h relocatable.h os2compat.h libgnuintl.h.in bindtextdom.c dcgettext.c dgettext.c gettext.c finddomain.c loadmsgcat.c localealias.c textdomain.c l10nflist.c explodename.c dcigettext.c dcngettext.c dngettext.c ngettext.c plural.y plural-exp.c localcharset.c relocatable.c localename.c log.c osdep.c os2compat.c intl-compat.c"; \
          for file in $dists; do \
            /usr/bin/install -c -m 644 ./$file \
                            /usr/share/gettext/intl/$file; \
          done; \
          chmod a+x /usr/share/gettext/intl/config.charset; \
          dists="plural.c"; \
          for file in $dists; do \
            if test -f $file; then dir=.; else dir=.; fi; \
            /usr/bin/install -c -m 644 $dir/$file \
                            /usr/share/gettext/intl/$file; \
          done; \
          dists="xopen-msg.sed linux-msg.sed po2tbl.sed.in cat-compat.c COPYING.LIB-2 gettext.h libgettext.h plural-eval.c libgnuintl.h"; \
          for file in $dists; do \
            rm -f /usr/share/gettext/intl/$file; \
          done; \
        else \
          : ; \
        fi
make[1]: Leaving directory `/home/jelle/tvtime/intl'
Making install in m4
make[1]: Entering directory `/home/jelle/tvtime/m4'
make[2]: Entering directory `/home/jelle/tvtime/m4'
make[2]: Nothing to be done for `install-exec-am'.
make[2]: Nothing to be done for `install-data-am'.
make[2]: Leaving directory `/home/jelle/tvtime/m4'
make[1]: Leaving directory `/home/jelle/tvtime/m4'
Making install in docs
make[1]: Entering directory `/home/jelle/tvtime/docs'
Making install in man
make[2]: Entering directory `/home/jelle/tvtime/docs/man'
Making install in de
make[3]: Entering directory `/home/jelle/tvtime/docs/man/de'
make[4]: Entering directory `/home/jelle/tvtime/docs/man/de'
make[4]: Nothing to be done for `install-exec-am'.
/bin/bash ../../../mkinstalldirs /usr/man/de/man1
mkdir -p -- /usr/man/de/man1
 /usr/bin/install -c -m 644 ./tvtime.1 /usr/man/de/man1/tvtime.1
 /usr/bin/install -c -m 644 ./tvtime-command.1 /usr/man/de/man1/tvtime-command.1
 /usr/bin/install -c -m 644 ./tvtime-configure.1 /usr/man/de/man1/tvtime-configure.1
 /usr/bin/install -c -m 644 ./tvtime-scanner.1 /usr/man/de/man1/tvtime-scanner.1
/bin/bash ../../../mkinstalldirs /usr/man/de/man5
mkdir -p -- /usr/man/de/man5
 /usr/bin/install -c -m 644 ./tvtime.xml.5 /usr/man/de/man5/tvtime.xml.5
 /usr/bin/install -c -m 644 ./stationlist.xml.5 /usr/man/de/man5/stationlist.xml.5
make[4]: Leaving directory `/home/jelle/tvtime/docs/man/de'
make[3]: Leaving directory `/home/jelle/tvtime/docs/man/de'
Making install in en
make[3]: Entering directory `/home/jelle/tvtime/docs/man/en'
make[4]: Entering directory `/home/jelle/tvtime/docs/man/en'
make[4]: Nothing to be done for `install-exec-am'.
/bin/bash ../../../mkinstalldirs /usr/man/man1
mkdir -p -- /usr/man/man1
 /usr/bin/install -c -m 644 ./tvtime.1 /usr/man/man1/tvtime.1
 /usr/bin/install -c -m 644 ./tvtime-command.1 /usr/man/man1/tvtime-command.1
 /usr/bin/install -c -m 644 ./tvtime-configure.1 /usr/man/man1/tvtime-configure.1
 /usr/bin/install -c -m 644 ./tvtime-scanner.1 /usr/man/man1/tvtime-scanner.1
/bin/bash ../../../mkinstalldirs /usr/man/man5
mkdir -p -- /usr/man/man5
 /usr/bin/install -c -m 644 ./tvtime.xml.5 /usr/man/man5/tvtime.xml.5
 /usr/bin/install -c -m 644 ./stationlist.xml.5 /usr/man/man5/stationlist.xml.5
make[4]: Leaving directory `/home/jelle/tvtime/docs/man/en'
make[3]: Leaving directory `/home/jelle/tvtime/docs/man/en'
Making install in es
make[3]: Entering directory `/home/jelle/tvtime/docs/man/es'
make[4]: Entering directory `/home/jelle/tvtime/docs/man/es'
make[4]: Nothing to be done for `install-exec-am'.
/bin/bash ../../../mkinstalldirs /usr/man/es/man1
mkdir -p -- /usr/man/es/man1
 /usr/bin/install -c -m 644 ./tvtime.1 /usr/man/es/man1/tvtime.1
 /usr/bin/install -c -m 644 ./tvtime-command.1 /usr/man/es/man1/tvtime-command.1
 /usr/bin/install -c -m 644 ./tvtime-configure.1 /usr/man/es/man1/tvtime-configure.1
 /usr/bin/install -c -m 644 ./tvtime-scanner.1 /usr/man/es/man1/tvtime-scanner.1
/bin/bash ../../../mkinstalldirs /usr/man/es/man5
mkdir -p -- /usr/man/es/man5
 /usr/bin/install -c -m 644 ./tvtime.xml.5 /usr/man/es/man5/tvtime.xml.5
 /usr/bin/install -c -m 644 ./stationlist.xml.5 /usr/man/es/man5/stationlist.xml.5
make[4]: Leaving directory `/home/jelle/tvtime/docs/man/es'
make[3]: Leaving directory `/home/jelle/tvtime/docs/man/es'
make[3]: Entering directory `/home/jelle/tvtime/docs/man'
make[4]: Entering directory `/home/jelle/tvtime/docs/man'
make[4]: Nothing to be done for `install-exec-am'.
make[4]: Nothing to be done for `install-data-am'.
make[4]: Leaving directory `/home/jelle/tvtime/docs/man'
make[3]: Leaving directory `/home/jelle/tvtime/docs/man'
make[2]: Leaving directory `/home/jelle/tvtime/docs/man'
make[2]: Entering directory `/home/jelle/tvtime/docs'
make[3]: Entering directory `/home/jelle/tvtime/docs'
make  install-exec-hook
make[4]: Entering directory `/home/jelle/tvtime/docs'
mkdir -p -- '/etc/tvtime' || touch noconfdir
if [ -f noconfdir ]; then                                           \
           rm -f noconfdir;                                                  \
         else                                                                \
           /usr/bin/install -c -m 'u=rw,go=r' 'html/default.tvtime.xml'               \
             '/etc/tvtime/tvtime.xml' || touch noconfdir;     \
         fi
make[4]: Leaving directory `/home/jelle/tvtime/docs'
/usr/bin/install -c -d '/usr/share/icons/hicolor/16x16/apps'
/usr/bin/install -c -d '/usr/share/icons/hicolor/32x32/apps'
/usr/bin/install -c -d '/usr/share/icons/hicolor/48x48/apps'
/usr/bin/install -c -d '/usr/share/pixmaps'
/usr/bin/install -c -m 644 './tvtime.16x16.png' '/usr/share/icons/hicolor/16x16/apps/tvtime.png'
/usr/bin/install -c -m 644 './tvtime.32x32.png' '/usr/share/icons/hicolor/32x32/apps/tvtime.png'
/usr/bin/install -c -m 644 './tvtime.48x48.png' '/usr/share/icons/hicolor/48x48/apps/tvtime.png'
/usr/bin/install -c -m 644 './tvtime.32x32.xpm' '/usr/share/pixmaps/tvtime.xpm'
/usr/bin/install -c -m 644 './tvtime.48x48.png' '/usr/share/pixmaps/tvtime.png'
/bin/bash ../mkinstalldirs /usr/share/applications
 /usr/bin/install -c -m 644 net-tvtime.desktop /usr/share/applications/net-tvtime.desktop
make[3]: Leaving directory `/home/jelle/tvtime/docs'
make[2]: Leaving directory `/home/jelle/tvtime/docs'
make[1]: Leaving directory `/home/jelle/tvtime/docs'
Making install in data
make[1]: Entering directory `/home/jelle/tvtime/data'
make[2]: Entering directory `/home/jelle/tvtime/data'
make[2]: Nothing to be done for `install-exec-am'.
/bin/bash ../mkinstalldirs /usr/share/tvtime
mkdir -p -- /usr/share/tvtime
 /usr/bin/install -c -m 644 FreeMonoBold.ttf /usr/share/tvtime/FreeMonoBold.ttf
 /usr/bin/install -c -m 644 tvtimeSansBold.ttf /usr/share/tvtime/tvtimeSansBold.ttf
 /usr/bin/install -c -m 644 filmstrip_0000.png /usr/share/tvtime/filmstrip_0000.png
 /usr/bin/install -c -m 644 filmstrip_0001.png /usr/share/tvtime/filmstrip_0001.png
 /usr/bin/install -c -m 644 filmstrip_0002.png /usr/share/tvtime/filmstrip_0002.png
 /usr/bin/install -c -m 644 filmstrip_0003.png /usr/share/tvtime/filmstrip_0003.png
 /usr/bin/install -c -m 644 filmstrip_0004.png /usr/share/tvtime/filmstrip_0004.png
 /usr/bin/install -c -m 644 infoicon_0000.png /usr/share/tvtime/infoicon_0000.png
make[2]: Leaving directory `/home/jelle/tvtime/data'
make[1]: Leaving directory `/home/jelle/tvtime/data'
Making install in plugins
make[1]: Entering directory `/home/jelle/tvtime/plugins'
make[2]: Entering directory `/home/jelle/tvtime/plugins'
make[2]: Nothing to be done for `install-exec-am'.
make[2]: Nothing to be done for `install-data-am'.
make[2]: Leaving directory `/home/jelle/tvtime/plugins'
make[1]: Leaving directory `/home/jelle/tvtime/plugins'
Making install in src
make[1]: Entering directory `/home/jelle/tvtime/src'
if gcc -DHAVE_CONFIG_H -I. -I. -I..    `/usr/bin/freetype-config --cflags`  -Wall -pedantic -I. -DDATADIR="\"/usr/share/tvtime\"" -DCONFDIR="\"/etc/tvtime\"" -DFIFODIR="\"/tmp\"" -D_LARGEFILE64_SOURCE -DLOCALEDIR="\"/usr/share/locale\"" -I../plugins  -I/usr/include/libxml2   -g  -O3 -fomit-frame-pointer -std=gnu99 -MT tvtime-videoinput.o -MD -MP -MF ".deps/tvtime-videoinput.Tpo" \
          -c -o tvtime-videoinput.o `test -f 'videoinput.c' || echo './'`videoinput.c; \
        then mv -f ".deps/tvtime-videoinput.Tpo" ".deps/tvtime-videoinput.Po"; \
        else rm -f ".deps/tvtime-videoinput.Tpo"; exit 1; \
        fi
In file included from videoinput.c:39:
videodev2.h:19:46: error: linux/compiler.h: No such file or directory
In file included from videoinput.c:42:
tvaudio.h:3:28: error: alsa/asoundlib.h: No such file or directory
In file included from videoinput.c:42:
tvaudio.h:7: error: expected specifier-qualifier-list before ‘snd_pcm_t’
videoinput.c: In function ‘videoinput_new’:
videoinput.c:489: error: ‘struct tvaudio’ has no member named ‘state’
make[1]: *** [tvtime-videoinput.o] Error 1
make[1]: Leaving directory `/home/jelle/tvtime/src'
make: *** [install-recursive] Error 1
jelle@xubutu-en12000e:~/tvtime$ cd ~


--------------050505000503000401010904
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------050505000503000401010904--
