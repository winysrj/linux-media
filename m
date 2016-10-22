Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55081 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936606AbcJVK4k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 06:56:40 -0400
Date: Sat, 22 Oct 2016 08:56:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161022085629.6ebbc4f6@vento.lan>
In-Reply-To: <20161021160543.264b8cf2@lwn.net>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
 <87oa2xrhqx.fsf@intel.com>
 <20161006103132.3a56802a@vento.lan>
 <87lgy15zin.fsf@intel.com>
 <20161006135028.2880f5a5@vento.lan>
 <8737k8ya6f.fsf@intel.com>
 <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
 <20161021160543.264b8cf2@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Oct 2016 16:05:43 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 11 Oct 2016 09:26:48 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
> > If the kernel-cmd directive gets acked, I will add a description to
> > kernel-documentation.rst and I request Mauro to document the parse-headers.pl
> > also.
> > 
> > But, let's hear what Jon says.  
> 
> Sigh.
> 
> I've been shunting this discussion aside while I dug out from other
> things.  Now I've pushed through the whole thing; I'm still not sure what
> I think is the best thing to do.
> 
> kernel-cmd scares me.  It looks like the ioctl() of documentation
> building; people will be able to add all kinds of wild things and it will
> take a lot of attention to catch them.  I think we could make things
> pretty messy in a real hurry.  And yes, I do think we should consider the
> security aspects of it; we're talking about adding another shell
> code-execution context in the kernel build, and that can only make things
> harder to audit.
> 
> OTOH, forcing things into dedicated Sphinx extensions doesn't necessarily
> fix the problem.  We're adding system calls rather than ioctl() commands,
> let's say, but we're still adding long-term maintenance complications.

The security implications will be the same if either coded as an
"ioctl()" or as "syscall", the scripts should be audited. Actually,
if we force the need of a "syscall" for every such script, we have
twice the code to audit, as both the Sphinx extension and the perl
script will need to audit, increasing the attack surface.

> How many special-case commands are we going to need to run?  Does it
> really need to go beyond what parse-headers is doing now?

Right now, we have actually 2 such cases: kernel-doc and parse-headers.

I also use a set of perl scripts that I manually run, on each Kernel
version, to update the cards list of several drivers. It is a total of
9 such scripts. See below for one of such example[1]

[1] this is actually new version of the script that produces the
Documentation/media/v4l-drivers/em28xx-cardlist.rst file, using a
flat table. The one used up to 4.9-rc1 were using a code-block tag.

The problem those scripts address is that there are several media boards that
don't have an unique PCI or USB ID, because they don't have eeproms, or
because the vendor sells different models with the very same ID
(for example, using one tuner for US market and another one for EU).

As there are no ways for the Kernel to auto-identify such boards,
the user need to pass two numbers for the driver, in order to set the
card and the tuner type, when modprobing the driver. 

Such drivers have those two parameters:

	parm:           tuner:tuner type (array of int)
	parm:           card:card type (array of int)

The tuner parameter define what TV tuner is present at the device(s).

The card number define things like GPIOs used to turn on the several
components of the board{s}, and describe the boards' capabilities.

Thankfully, we only have a couple of new additions to those drivers
per Kernel release, so, right now, I take myself the burden of manually
run those scripts, but if we could add it to the building system, that would
reduce a a little bit my workload, with is a good thing :) It would also
prevent the risk of releasing a Kernel with outdated information, with
sometimes happen.

I've no idea if we'll either need scripts or not on other non-media docs.

>  Let's really
> think about what the other use cases might be and whether we can do
> without them. I'm still thoroughly unconvinced about the utility of
> incorporating, say, the MAINTAINERS file into the formatted docs, for
> example, so I'm not yet convinced that making that easier to do is
> something we need.

With regards to MAINTAINERS, what's your suggestion? 

Right now, there are cross-references for it in 58 places, being 25 on a
documentation file, including README and REPORTING-BUGS, with has a broader
audience.

IMHO, we should provide a section somehow at the documentation
in order to give directions if someone reads one of such documents.

Also, the section "List of maintainers and how to submit kernel changes"
Has a short list of rules for people to follow when submitting a patch,
with could make sense at the process book.

So, I can see some ways to handle it:

1) convert everything, including the database to ReST and include
   it at documentation;

2) convert it to ReST format, except for the database, and use some
   extension to parse it, like on my PoC patches;

3) move the "how to submit kernel changes" list to process/ and
   create a small guide at the admin-guide/ book to be used as
   cross-reference to MAINTAINERS, explaining how to get the
   maintainer for a file (e. g. running ./scripts/get-maintainer.pl);

4) do nothing and assume that anyone capable of reading the
   README or REPORTING-BUGS file would guess what "MAINTAINERS" mean
   (or that if then won't guess, we don't want bug reports from them).


> 
> Not much clarity here, sorry.
> 
> jon

Thanks,
Mauro

---
	
#!/usr/bin/perl -w
use strict;

my $new_entry = -1;
my $nr = 0;
my ($id,$subvendor,$subdevice);
my %data;

my $debug = 0;

while (<>) {
	# defines in header file
	if (/#define\s+(EM2[\d]+_BOARD_[\w\d_]+)\s+(\d+)/) {
		printf("$1 = $2\n") if ($debug);
		$data{$1}->{nr} = $2;
		next;
	}
	# em2820_boards
	if (/\[(EM2820_BOARD_[\w\d_]+)\]/) {
		$id = $1;
		printf("ID = $id\n") if $debug;
		$data{$id}->{id} = $id;
		$data{$id}->{type} = "em2820 or em2840";
		$data{$id}->{qtd}++;
	} elsif (/\[(EM)(2[\d]+)(_BOARD_[\w\d_]+)\]/) {
		$id = "$1$2$3";
		printf("ID = $id\n") if $debug;
		$data{$id}->{id} = $id;
		$data{$id}->{type} = "em$2";
		$data{$id}->{qtd}++;
	};

	next unless defined($id);

	if (/USB_DEVICE.*0x([0-9a-fA-F]+)\s*\,\s*0x([0-9a-fA-F]+)/ ) {
		$subvendor=$1;
		$subdevice=$2;
	}

	if (/.*driver_info.*(EM2[\d]+_BOARD_[\w\d_]+)/ ) {
		push @{$data{$1}->{subid}}, "$subvendor:$subdevice";
	}

	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
		$data{$id}->{name} = $1 if (/\.name\s*=\s*\"([^\"]+)\"/);
		if (defined $data{$id}->{name} && $debug) {
			printf("name[$id] = %s\n", $data{$id}->{name});
		}
	}
}

print "EM28xx cards list\n";
print "=================\n\n";

print ".. flat-table::\n";
print "    :header-rows:  1\n";
print "    :stub-columns: 0\n";
print "    :widths:       10 50 15 50\n\n";
print "    * - Card number\n";
print "      - Card name\n";
print "      - Empia Chip\n";
print "      - USB IDs\n\n";

foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
	printf "    * - %s\n", $data{$item}->{nr};
	printf "      - %s\n", $data{$item}->{name};
	printf "      - %s\n", $data{$item}->{type};
	if ($data{$item}->{subid}) {
		printf "      - %s\n", join(", ",@{$data{$item}->{subid}})
	} else {
		printf "      -\n";
	}
	printf "\n";

	printf "(%d entires)", $data{$item}->{qtd} if ($debug);
}

