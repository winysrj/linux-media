Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6VBVMH4006026
	for <video4linux-list@redhat.com>; Sat, 31 Jul 2010 07:31:22 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6VBV7gm030486
	for <video4linux-list@redhat.com>; Sat, 31 Jul 2010 07:31:12 -0400
Date: Sat, 31 Jul 2010 13:32:01 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sudhindra Nayak <sudhindra.nayak@gmail.com>
Subject: Re: Not able to capture video frames
Message-ID: <20100731133201.79939101@tele>
In-Reply-To: <1280489451608-5354598.post@n2.nabble.com>
References: <1280489451608-5354598.post@n2.nabble.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/CB+8vvfhsD.hXD9EotgXhzV"
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--MP_/CB+8vvfhsD.hXD9EotgXhzV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 30 Jul 2010 04:30:51 -0700 (PDT)
Sudhindra Nayak <sudhindra.nayak@gmail.com> wrote:

> I'm using the 'Omnivision' ov538 camera bridge processor along with an
> ov10620 CMOS sensor. I'm using a driver which I got from the
> following link:
>=20
> http://lwn.net/Articles/308358/
>=20
> I've modified the driver by inserting printk statements in the driver
> code to understand the flow of control between functions. I've also
> changed the arguments passed to the 'sccb_reg_write' function to
> values corresponding to the ov10620 sensor.=20
>=20
> I'm using a v4l2 example code as my application along with the above
> mentioned driver. The example code can be found at the below link:
>=20
> http://v4l2spec.bytesex.org/spec/capture-example.html
>=20
> When I run the application after inserting the driver, it calls the
> open_device(), init_device() and start_capturing() functions and then
> enters the mainloop() function. In the mainloop() function, the
> select() function call times out after 2 seconds and I'm not able to
> capture any video frames.
>=20
> I'm also receiving some errors like:
>=20
> gspca: ISOC data error: [3] len=3D56, status=3D-71
> gspca: ISOC data error: [4] len=3D12, status=3D-71
>=20
> This repeats with different values for 'len' and the value in [ ].

Hi Sudhindra,

First, the mailing list for linux video is now
linux-media@vger.kernel.org.

Then, the ov534 which appeared in lwn is rather old. The last gspca
stable version may be found at LinuxTv.org, and there is a test version
as a tarball in my home page (see below).

The error in the ISOC messages are set by the webcam. It means that the
initialization is not complete/correct. To facilitate your job, I join
a Tcl script which parses the output of sniffbin (USB sniffer on ms-win)
giving a more compact and readable trace.

BTW, I could include your driver in the Linux kernel as soon as it will
work...

Best regards.

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/CB+8vvfhsD.hXD9EotgXhzV
Content-Type: text/x-tcl
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=parsnoop.tcl

#!/bin/sh
# -*- tcl -*- \
exec tclsh "$0" ${1+"$@"}

proc usage {} {
	puts "Parse a ms-win USB snoop
Usage:
	parsnoop \[options\] <usbsnoop file>
Options:
	-nb	Don't display the Bulk/Interrupt messages
	-ni	Don't display the Isochronous messages
	-t	Display the delta time between exchanges"
	exit
}

proc isoc {fd} {
	global deltatime noisoc
	set in 0
	while {[gets $fd line] >= 0} {
		switch -regexp -- $line {
		    "  URB " break
		    StartFrame {
			if {[string compare [lindex $line 2] 00000000] != 0} {
				set in 1
			}
		    }
		    TransferBufferLength {
			set l [lindex $line 2]
		    }
		    NumberOfPackets {
			set n [lindex $line 2]
		    }
		}
	}
	if {!$in || $noisoc} {
		return $line
	}
	puts -nonewline $deltatime
	puts [format "<isoc \[%d\] l:%d" 0x$n 0x$l]
	return $line
}

proc vendor {fd} {
# outgoing message
	global deltatime
	set out 0
	set b {}
	while {[gets $fd line] >= 0} {
		switch -regexp -- $line {
		    "  URB " break
		    DIRECTION_OUT {
			set out 1
		    }
		    TransferBufferLength {
#			set l 0x[lindex $line 3]
		    }
		    00000..0: {
			if {$out} {
				if {[string length $b] != 0} {
					append b "\n\t\t  "
				}
				append b [lrange $line 1 end]
			}
		    }
		    "Request" {
			set r [format %02x 0x[lindex $line 2]]
		    }
		    "Value" {
			set v [format %04x 0x[lindex $line 2]]
		    }
		    "Index" {
			set i [format %04x 0x[lindex $line 2]]
		    }
		}
	}
	if {$out} {
		puts -nonewline $deltatime
		puts " SET $r $v $i $b"
	}
	return $line
}

proc ctrl {fd} {
# incoming message
	global deltatime
	set in 0
	set b {}
	set setup 0
	while {[gets $fd line] >= 0} {
		switch -regexp -- $line {
		    "  URB " break
		    DIRECTION_IN {
			set in 1
		    }
		    SetupPacket {
			set setup 1
		    }
		    "  00000" {
			if {!$in} continue
			if {!$setup} {
				if {[string length $b] == 0} {
					set b [lrange $line 1 end]
				} else {
					append b "\n<\t\t  "
					append b [lrange $line 1 end]
				}
			} else {
				set r [lindex $line 2]
				set v [lindex $line 4][lindex $line 3]
				set i [lindex $line 6][lindex $line 5]
			}
		    }
		}
	}
	if {$in} {
		puts -nonewline $deltatime
		puts "<GET $r $v $i $b"
	}
	return $line
}

proc interf {fd} {
# select interface
	global deltatime
	set i {??}
	set a {??}
	while {[gets $fd line] >= 0} {
		switch -regexp -- $line {
		    "  URB " break
		    InterfaceNumber {
			set i [format %02x 0x[lindex $line 3]]
		    }
		    AlternateSetting {
			set a [format %02x 0x[lindex $line 3]]
		    }
		}
	}
	puts -nonewline $deltatime
	puts " intf $i alt $a"
	return $line
}

proc feature {fd} {
	global deltatime
	while {[gets $fd line] >= 0} {
		switch -regexp -- $line {
		    "  URB " break
		}
	}
puts -nonewline $deltatime
puts "feature"
	return $line
}

proc transf {fd} {
# bulk or interrupt transfer
	global deltatime nobulk
	set in 0
	set b {}
	while {[gets $fd line] >= 0} {
		switch -regexp -- $line {
		    DIRECTION_IN {
			set in 1
		    }
		    "  000000" {
			if {!$nobulk} {
			    if {[string length $b] == 0} {
				set b [lrange $line 1 end]
			    } else {
				append b "\n\t      "
				append b [lrange $line 1 end]
			    }
			}
		    }
		    "  00000100" {
			if {!$nobulk} {
				append b "\n\t      ..."
			}
		    }
		    "  URB " break
		}
	}
	if {$nobulk || [string length $b] == 0} {
		return $line
	}
	puts -nonewline $deltatime
	if {$in} {
		puts "<Bulk/Int IN  $b"
	} else {
		puts " Bulk/Int OUT $b"
	}
	return $line
}

proc main {argv} {
	global nowtime prevtime withtime deltatime nobulk noisoc
	set withtime 0
	set nobulk 0
	set noisoc 0
	set deltatime {}
	set fn {}
	foreach a $argv {
		switch -- $a {
		    -t {
			set withtime 1
		    }
		    -nb {
			set nobulk 1
		    }
		    -ni {
			set noisoc 1
		    }
		    default {
			if {[string length $fn] != 0} usage
			set fn $a
		    }
		}
	}
	if {[string length $fn] == 0} usage
	if {[catch {open $fn r} fd]} {
		puts "cannot open '$fn'"
		exit 1
	}
	set nowtime 0
	set prevtime 0
	set nisoc 0
	while {[gets $fd line] >= 0} {
		set isoc 0
		switch -regexp -- $line {
		    URB_FUNCTION_ISOCH_TRANSFER {
			set line [isoc $fd]
			set isoc 1
			incr nisoc
		    }
		    URB_FUNCTION_VENDOR {
			set line [vendor $fd]
		    }
		    URB_FUNCTION_CONTROL_TRANSFER {
			set line [ctrl $fd]
		    }
		    URB_FUNCTION_SELECT_INTERFACE {
			set line [interf $fd]
		    }
		    URB_FUNCTION_SET_FEATURE_TO_DEVICE {
			set line [feature $fd]
		    }
		    URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER {
			set line [transf $fd]
		    }
		}
		if {!$noisoc && !$isoc && $nisoc != 0} {
			puts -nonewline $deltatime
			puts "$nisoc isoc"
			set nisoc 0
		}
		if {[regexp {\[([0-9]+) ms\]} $line dum ntime]} {
			set prevtime $nowtime
			set nowtime $ntime
			if {[string first down $line] > 0} {
				if {$withtime} {
					set deltatime [format "%4d " \
						[expr {$nowtime - $prevtime}]]
				} elseif {$nowtime > $prevtime + 2} {
					puts "== +[expr {$nowtime - $prevtime}] ms"
				}
			}
			if {$nowtime > $prevtime + 200} {
				puts "== \[$nowtime ms\]"
			}
		}
	}
}

main $argv

--MP_/CB+8vvfhsD.hXD9EotgXhzV
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/CB+8vvfhsD.hXD9EotgXhzV--
