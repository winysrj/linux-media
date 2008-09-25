Return-path: <video4linux-list-bounces@redhat.com>
Date: Thu, 25 Sep 2008 07:39:32 -0400
From: Alan Cox <alan@redhat.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Message-ID: <20080925113932.GA21999@shell.devel.redhat.com>
References: <208cbae30809250429m64c1c552ud18ff5064602e3c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208cbae30809250429m64c1c552ud18ff5064602e3c0@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: radio-mr800 usb driver
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

On Thu, Sep 25, 2008 at 03:29:55PM +0400, Alexey Klimov wrote:
> First of all - sorry for my english.

Your English is fine...

> Driver works fine with kradio & gnomeradio applications. Works normal
> under Linux kernel  2.6.27-rc6 (released 9 Sep 2008), compiles without
> warnings with gcc version 4.3.1 (Gentoo 4.3.1-r1 p1.1) on
> x86-architecture machine.

Looks nice and clean to me. No obvious mistakes. Probably the warn()
statements should include the module name so people know which module
produced them if they ever want to file a bug.

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
