Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2DCpMNY017255
	for <video4linux-list@redhat.com>; Fri, 13 Mar 2009 08:51:22 -0400
Received: from mail-bw0-f160.google.com (mail-bw0-f160.google.com
	[209.85.218.160])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2DCowHL019850
	for <video4linux-list@redhat.com>; Fri, 13 Mar 2009 08:50:59 -0400
Received: by bwz4 with SMTP id 4so2665138bwz.3
	for <video4linux-list@redhat.com>; Fri, 13 Mar 2009 05:50:57 -0700 (PDT)
Message-ID: <49BA56AF.9040101@lfarkas.org>
Date: Fri, 13 Mar 2009 13:50:55 +0100
From: Farkas Levente <lfarkas@lfarkas.org>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <49BA4E22.20209@hhs.nl>
In-Reply-To: <49BA4E22.20209@hhs.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Re: libv4l release: 0.5.9
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

Hans de Goede wrote:
> Hi All,
> 
> Add support for various new formats, see the changelog entry below:
> 
> libv4l-0.5.9
> ------------
> * Add support for MR97310A decompression by Kyle Guinn <elyk03@gmail.com>
> * Add support for sq905c decompression by Theodore Kilgore
>   <kilgota@auburn.edu>
> * Add hm12 support for the cx2341x MPEG encoder devices by Hans Verkuil
>   <hverkuil@xs4all.nl>
> 
> 
> Get it here:
> http://people.atrpms.net/~hdegoede/libv4l-0.5.9.tar.gz

is there any plan to be compile on epel-5 to? it's currently can't
compile on it.
yours.

gcc -c -MMD -I../include -I../../../include -fvisibility=hidden -fPIC
-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions
-fstack-protector --param=ssp-buffer-size=4 -m32 -march=i386
-mtune=generic -fasynchronous-unwind-tables -o sn9c20x.o sn9c20x.c
In file included from libv4lconvert-priv.h:24,
                 from sn9c20x.c:25:
../include/libv4lconvert.h:77: warning: 'struct v4l2_frmsizeenum'
declared inside parameter list
../include/libv4lconvert.h:77: warning: its scope is only this
definition or declaration, which is probably not what you want
../include/libv4lconvert.h:82: warning: 'struct v4l2_frmivalenum'
declared inside parameter list
In file included from sn9c20x.c:25:
libv4lconvert-priv.h:104: error: array type has incomplete element type
sn9c20x.c: In function 'v4lconvert_sn9c20x_to_yuv420':
sn9c20x.c:81: warning: unused variable 'height_div2'
make[1]: *** [sn9c20x.o] Error 1
make[1]: *** Waiting for unfinished jobs....
In file included from libv4lconvert-priv.h:24,
                 from sn9c10x.c:25:
../include/libv4lconvert.h:77: warning: 'struct v4l2_frmsizeenum'
declared inside parameter list
../include/libv4lconvert.h:77: warning: its scope is only this
definition or declaration, which is probably not what you want
../include/libv4lconvert.h:82: warning: 'struct v4l2_frmivalenum'
declared inside parameter list
In file included from sn9c10x.c:25:
libv4lconvert-priv.h:104: error: array type has incomplete element type
make[1]: *** [sn9c10x.o] Error 1
In file included from libv4lconvert.c:27:
../include/libv4lconvert.h:77: warning: 'struct v4l2_frmsizeenum'
declared inside parameter list
../include/libv4lconvert.h:77: warning: its scope is only this
definition or declaration, which is probably not what you want
../include/libv4lconvert.h:82: warning: 'struct v4l2_frmivalenum'
declared inside parameter list
In file included from libv4lconvert.c:28:
libv4lconvert-priv.h:104: error: array type has incomplete element type
libv4lconvert.c: In function 'v4lconvert_get_framesizes':
libv4lconvert.c:921: error: variable 'frmsize' has initializer but
incomplete type
libv4lconvert.c:921: error: unknown field 'pixel_format' specified in
initializer
libv4lconvert.c:921: warning: excess elements in struct initializer
libv4lconvert.c:921: warning: (near initialization for 'frmsize')
libv4lconvert.c:921: error: storage size of 'frmsize' isn't known
libv4lconvert.c:925: error: 'VIDIOC_ENUM_FRAMESIZES' undeclared (first
use in this function)
libv4lconvert.c:925: error: (Each undeclared identifier is reported only
once
libv4lconvert.c:925: error: for each function it appears in.)
libv4lconvert.c:935: error: 'V4L2_FRMSIZE_TYPE_DISCRETE' undeclared
(first use in this function)
libv4lconvert.c:940: error: 'V4L2_FRMSIZE_TYPE_CONTINUOUS' undeclared
(first use in this function)
libv4lconvert.c:941: error: 'V4L2_FRMSIZE_TYPE_STEPWISE' undeclared
(first use in this function)
libv4lconvert.c:921: warning: unused variable 'frmsize'
libv4lconvert.c: At top level:
libv4lconvert.c:979: error: conflicting types for
'v4lconvert_enum_framesizes'
../include/libv4lconvert.h:77: error: previous declaration of
'v4lconvert_enum_framesizes' was here
libv4lconvert.c: In function 'v4lconvert_enum_framesizes':
libv4lconvert.c:980: error: dereferencing pointer to incomplete type
libv4lconvert.c:981: error: 'VIDIOC_ENUM_FRAMESIZES' undeclared (first
use in this function)
libv4lconvert.c:983: error: dereferencing pointer to incomplete type
libv4lconvert.c:988: error: dereferencing pointer to incomplete type
libv4lconvert.c:988: error: dereferencing pointer to incomplete type
libv4lconvert.c:989: error: dereferencing pointer to incomplete type
libv4lconvert.c:990: error: 'V4L2_FRMSIZE_TYPE_DISCRETE' undeclared
(first use in this function)
libv4lconvert.c:991: error: dereferencing pointer to incomplete type
libv4lconvert.c:991: error: dereferencing pointer to incomplete type
libv4lconvert.c:993: error: 'V4L2_FRMSIZE_TYPE_CONTINUOUS' undeclared
(first use in this function)
libv4lconvert.c:994: error: 'V4L2_FRMSIZE_TYPE_STEPWISE' undeclared
(first use in this function)
libv4lconvert.c:995: error: dereferencing pointer to incomplete type
libv4lconvert.c:995: error: dereferencing pointer to incomplete type
libv4lconvert.c: At top level:
libv4lconvert.c:1003: warning: 'struct v4l2_frmivalenum' declared inside
parameter list
libv4lconvert.c:1004: error: conflicting types for
'v4lconvert_enum_frameintervals'
../include/libv4lconvert.h:82: error: previous declaration of
'v4lconvert_enum_frameintervals' was here
libv4lconvert.c: In function 'v4lconvert_enum_frameintervals':
libv4lconvert.c:1008: error: dereferencing pointer to incomplete type
libv4lconvert.c:1009: error: 'VIDIOC_ENUM_FRAMEINTERVALS' undeclared
(first use in this function)
libv4lconvert.c:1018: error: dereferencing pointer to incomplete type
libv4lconvert.c:1019: error: dereferencing pointer to incomplete type
libv4lconvert.c:1020: error: dereferencing pointer to incomplete type
libv4lconvert.c:1028: error: dereferencing pointer to incomplete type
libv4lconvert.c:1029: error: dereferencing pointer to incomplete type
libv4lconvert.c:1030: error: dereferencing pointer to incomplete type
libv4lconvert.c:1031: error: dereferencing pointer to incomplete type
libv4lconvert.c:1033: error: dereferencing pointer to incomplete type
libv4lconvert.c:1033: error: dereferencing pointer to incomplete type
libv4lconvert.c:1050: error: dereferencing pointer to incomplete type
libv4lconvert.c:1051: error: dereferencing pointer to incomplete type
libv4lconvert.c:1052: error: dereferencing pointer to incomplete type
libv4lconvert.c:1057: error: dereferencing pointer to incomplete type
libv4lconvert.c:1073: error: dereferencing pointer to incomplete type
libv4lconvert.c:1074: error: dereferencing pointer to incomplete type
libv4lconvert.c:1075: error: dereferencing pointer to incomplete type
make[1]: *** [libv4lconvert.o] Error 1


-- 
  Levente                               "Si vis pacem para bellum!"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
