Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:39273 "HELO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751388AbZLMIr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 03:47:56 -0500
Date: Sun, 13 Dec 2009 09:48:06 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Francesco Lavra <francescolavra@interfree.it>
Cc: linux-media@vger.kernel.org
Subject: Re: Adding support for Benq DC E300 camera
Message-ID: <20091213094806.239b3b9d@tele>
In-Reply-To: <1260646884.23354.22.camel@localhost>
References: <1260646884.23354.22.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/zA8IVe/xJCumfE5xK40+cnA"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/zA8IVe/xJCumfE5xK40+cnA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 12 Dec 2009 20:41:24 +0100
Francesco Lavra <francescolavra@interfree.it> wrote:
> I'm trying to get my Benq DC E300 camera to work under Linux.
> It has an Atmel AT76C113 chip. I don't know how many Linux users would
> benefit from a driver supporting this camera (and possibly other
> models, too), so my question is: if/when such a driver will be
> written, is there someone willing to review it and finally get it
> merged? If the answer is yes, I will try to write something working.
>=20
> This camera USB interface has 10 alternate settings, and altsetting 5
> is used to stream data; it uses two isochronous endpoints to transfer
> an AVI-formatted video stream (320x240) to the USB host.
> It would be great if someone could give me some information to make
> writing the driver easier: so far, I have only USB sniffer capture
> logs from the Windows driver.

Hi Francesco,

gspca already handles some cameras and some Benq webcams. From a USB
snoop, it may be easy to write a new gspca subdriver.

I join the tcl script I use to extract the important information from
raw snoop traces. May you send me the result with your logs? Then, I
could see if an existing subdriver could be used or if a new one has to
be created.

Regards.

--=20
Ken ar c'henta=F1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/zA8IVe/xJCumfE5xK40+cnA
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

--MP_/zA8IVe/xJCumfE5xK40+cnA--
