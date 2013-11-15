Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab3KOCPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Nov 2013 21:15:47 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20271.1384472102@warthog.procyon.org.uk>
References: <20271.1384472102@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103 driver
Date: Fri, 15 Nov 2013 02:15:12 +0000
Message-ID: <10636.1384481712@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> Here are four logs from doing:
> 
> 	scandvb -a1 ./e.1
> 
> where the contents of file e.1 are:
> 
> 	S 11919000 V 27500000 3/4
> 
> which is probing a region on the Eutelsat-9A satellite broadcast.

Here's a script for turning the logs from:

	I2C cx23885[0]: RD 60 1
	I2C m88ds3103: WR 60 2 [0003]
	I2C cx23885[0]: WR 68 2 [0311]
	I2C cx23885[0]: WR 60 2 [0003]
	I2C m88ds3103: WR 60 1 [00]

into something that looks like:

	demod_read(23)
	demod_write(23, [1f])
	TUNER_read(00)
	TUNER_write(00, [03])
	TUNER_read(00)

and checks for and hides the tuner gate opening commands to the ds3103.

David
---
#!/usr/bin/perl -w

use strict;

my $last_adap = 0;
my $last_dev = 0;
my $last_reg = 0;
my $tuner_gate = 0;

while (<>) {
    chomp;
    if (/^I2C ([^:]*): RD ([0-9A-Fa-f]{2}) ([0-9]{1,2})/) {
	my $adap = $1;
	my $dev = $2;
	my $n = $3;

	die if ($dev ne "6b" && $dev ne $last_dev);

	if ($dev eq "68") {
	    # Demodulator register
	    die if ($tuner_gate);
	    print "demod_read(", $last_reg, ")\n";
	} elsif ($dev eq "60") {
	    # Tuner register

	    # Ignore stuff on the internal tuner->demod bus in Antti's driver
	    next if ($adap eq "m88ds3103");

	    die if (!$tuner_gate);
	    $tuner_gate = 0;
	    print "TUNER_read(", $last_reg, ")\n";
	} else {
	    print "RD ", $adap, " ", $dev, " ", $n, "\n";
	}

    } elsif (/^I2C ([^:]*): WR ([0-9A-Fa-f]{2}) ([0-9]{1,2}) [[]([0-9A-Fa-f]{2,})[]]/) {
	my $adap = $1;
	my $dev = $2;
	my $n = $3;
	my $data = $4;

	$last_adap = $adap;
	$last_dev = $dev;

	die if (int($n) <= 0);
	die if (length($data) != int($n) * 2);

	if ($dev eq "68") {
	    # Demodulator register
	    die if ($tuner_gate);
	    my $reg = substr($data, 0, 2);
	    if ($n == 2 && $data eq "0311") {
		$tuner_gate = 1;
	    } elsif ($n > 1) {
		print "demod_write(", $reg, ", [", substr($data, 2), "])\n";
		$last_dev = 0;
	    } else {
		$last_reg = $reg;
	    }
	} elsif ($dev eq "60") {
	    # Tuner register

	    # Ignore stuff on the internal tuner->demod bus in Antti's driver
	    next if ($adap eq "m88ds3103");

	    die if (!$tuner_gate);
	    my $reg = substr($data, 0, 2);
	    if ($n > 1) {
		print "TUNER_write(", $reg, ", [", substr($data, 2), "])\n";
		$last_dev = 0;
		$tuner_gate = 0;
	    } else {
		$last_reg = $reg;
	    }
	} else {
	    print "WR ", $1, " ", $2, " ", $3, " ", $4, "\n";
	}
    } else {
	print;
	print "\n";
    }
}
