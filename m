Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2AGMTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 07:19:48 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q07CJlsU019947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 7 Jan 2012 07:19:47 -0500
Received: from [10.3.231.107] (vpn-231-107.phx2.redhat.com [10.3.231.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q07CJh5W029473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 7 Jan 2012 07:19:46 -0500
Message-ID: <4F08385E.7050602@redhat.com>
Date: Sat, 07 Jan 2012 10:19:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] DVBv5 tools version 0.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As previously commented at the ML, I'm developing a set of tools
using DVBv5 API. Instead of starting from something existing,
I decided to start from scratch, in order to avoid polluting it
with DVBv3 legacy stuff. Of course, I did some research inside
the existing tools, in order to fill in the blanks, using the
dvb-apps tzap as a reference for the first real application on it,
but removing a large amount of code (file parsers, etc).

They're now on a good shape, at least for my own usage ;)

In order to test, you should use:

git clone git://linuxtv.org/mchehab/experimental-v4l-utils.git

And then run "make". the utils are inside utils/dvb.

I plan to do some cleanup at the patches later (basically, changing
the patch descriptions), and add it inside the v4l-utils, in order 
to have the basic tools I use for testing media devices into the
same place.

DVB TOOLS
=========

This is a series of tools written to help testing and working with DVB,
using its latest V5 API. The tools can also work with the DVBv3 API.

The current tools are:

dvb-fe-tool - a simple test application, that reads from the frontend.
	      it also allows to change the default delivery system.
	      In the future, it may be used to change any property
	      via command line.

dvb-format-convert - converts from zap and scan "initial-tuning-data-file"
	      into the new format defined to work with DVBv5;

dvbv5-scan - a DVBv5 scan tool;

dvbv5-zap - a DVBv5 zap tool. It allow to tune into a DVB channel, and
	    to watch to a DVB service (e. g. receiving the video and audio
	    streams, via another application using the dvr device).

Each application code is very small, as most of the code are on some
generic code that will become a library in the future.

CONTENTS OF THE TREE
====================

parse_string.c/parse_string.h: MPEG-TS string decoder with charset translator

Used to decode NIT/SDT service name, network provider and provider name.
It parses the charsets according with the DVB specs, converting them into
UTF-8 (or other charset), using iconv library.

descriptors.c/descriptors.h:  MPEG-TS descriptors parser

The code there is generig enough to decode the MPEG-TS descriptors,
with the DVB and other Digital TV extensions.

libscan.c/libscan/h: DVBv5 scanning library

This library is used to retrieve DVB information from the MPEG TS
headers, discovering the services associated to each DVB channel or
transponder. The services information is the basic info that most
DVB tools need to tune into a channel.

dvb-file.c/dvb-file.h: DVB file read/write library.

Allows parsing a DVB file (legacy or not) and to write data into a
DVB file (new format only).

dvb-fe.c/dvb-fe.h: DVB frontend library.

Allows talking with a DVB frontend via DVBv5 or DVBv3 API.

dvb-zap-format.c/dvb-legacy-channel-format.c:

Contains the data structures required in order to read from the legacy
formats (zap or scan "initial-tuning-data-file").

dvb_frontend.h: DVBv5 frontend API.

This is just a copy of the newest linux/dvb/frontend.h header.
I opted to keep a copy there, in order to allow working with the tools
without needing to copy the latest header into /usr/include.

dvb-v5.h/dvb-v5-std.h:

Ancillary files linked into dvb-fe code, used to parse DVB tables. The
dvbv5.h is generated by a small perl util, from the DVB FE API file.

dvb-demux.c/dvb-demux.h: DVB demux library.

Used by the dvbv5-zap utility.

dvb-fe-tool.c, dvb-format-convert.c, dvbv5-zap.c, dvbv5-scan.c: tools code.

Basically, parses the options from userspace and calls the other code
to do what was requested by the user.

CHANNEL/SERVICE FILE FORMAT
===========================

Instead of having two different files, one for services, and another for
channels/transponders, I opted to use just one format for both. The
format is:

[channel]
key1=value1
key2=value2
key3=value3
...
keyn=valuen


lines with # are discarted by the parsers. Also, whitespaces/tabs before
the keys and before/after the equal sign.

Be careful: whitespace in the middle of the value are not discarded.

A typical service would be like:

[TV Brasil HD]
        VCHANNEL = 2.2
        SERVICE_ID = 16160
        VIDEO_PID = 770
        AUDIO_PID = 514 614
        FREQUENCY = 479142857
        MODULATION = QAM/AUTO
        BANDWIDTH_HZ = 6000000
        INVERSION = AUTO
        CODE_RATE_HP = AUTO
        CODE_RATE_LP = NONE
        GUARD_INTERVAL = AUTO
        TRANSMISSION_MODE = AUTO
        HIERARCHY = NONE
        ISDBT_LAYER_ENABLED = 7
        ISDBT_PARTIAL_RECEPTION = 0
        ISDBT_SOUND_BROADCASTING = 0
        ISDBT_SB_SUBCHANNEL_ID = 0
        ISDBT_SB_SEGMENT_IDX = 0
        ISDBT_SB_SEGMENT_COUNT = 0
        ISDBT_LAYERA_FEC = AUTO
        ISDBT_LAYERA_MODULATION = QAM/AUTO
        ISDBT_LAYERA_SEGMENT_COUNT = 0
        ISDBT_LAYERA_TIME_INTERLEAVING = 0
        ISDBT_LAYERB_FEC = AUTO
        ISDBT_LAYERB_MODULATION = QAM/AUTO
        ISDBT_LAYERB_SEGMENT_COUNT = 0
        ISDBT_LAYERB_TIME_INTERLEAVING = 0
        ISDBT_LAYERC_FEC = AUTO
        ISDBT_LAYERC_MODULATION = QAM/AUTO
        ISDBT_LAYERC_SEGMENT_COUNT = 0
        ISDBT_LAYERC_TIME_INTERLEAVING = 0
        DELIVERY_SYSTEM = ISDBT

Just the channel description for it would be:

[CHANNEL]
        FREQUENCY = 479142857
        MODULATION = QAM/AUTO
        BANDWIDTH_HZ = 6000000
        INVERSION = AUTO
        CODE_RATE_HP = AUTO
        CODE_RATE_LP = NONE
        GUARD_INTERVAL = AUTO
        TRANSMISSION_MODE = AUTO
        HIERARCHY = NONE
        ISDBT_LAYER_ENABLED = 7
        ISDBT_PARTIAL_RECEPTION = 0
        ISDBT_SOUND_BROADCASTING = 0
        ISDBT_SB_SUBCHANNEL_ID = 0
        ISDBT_SB_SEGMENT_IDX = 0
        ISDBT_SB_SEGMENT_COUNT = 0
        ISDBT_LAYERA_FEC = AUTO
        ISDBT_LAYERA_MODULATION = QAM/AUTO
        ISDBT_LAYERA_SEGMENT_COUNT = 0
        ISDBT_LAYERA_TIME_INTERLEAVING = 0
        ISDBT_LAYERB_FEC = AUTO
        ISDBT_LAYERB_MODULATION = QAM/AUTO
        ISDBT_LAYERB_SEGMENT_COUNT = 0
        ISDBT_LAYERB_TIME_INTERLEAVING = 0
        ISDBT_LAYERC_FEC = AUTO
        ISDBT_LAYERC_MODULATION = QAM/AUTO
        ISDBT_LAYERC_SEGMENT_COUNT = 0
        ISDBT_LAYERC_TIME_INTERLEAVING = 0
        DELIVERY_SYSTEM = ISDBT

CURRENT ISSUES
==============

The dvb-fe-tool and the dvb-format-convert are generic enough to work
with all delivery systems. However, the other two tools need to do
some diferent things, depending on the delivery system.

I'm currently with only ISDB-T signals here, so the other two
tools were tested only with it.

The dvbv5-zap in general won't work with Satellite delivery
systems. It lacks polarity settings, and it doesn't know anything
about LNB or DISEqC. It shouldn't hard to port those things into it, 
but a DVB-S signal is needed to test. As I don't have it curently,
I'm not working to add support for it at the moment. 

Patches are welcome.

The dvbv5-scan also won't work with Satellite delivery systems
due to the same reasons.

Patches are welcome.

The dvbv5-scan should likely work with the other standards, but the
descriptor parser for NIT, PAT, PMT and SDT tables are fine-tuned
for ISDB-T. Adding more parsed info there could help to improve the
detected things, like virtual channels. Maybe some additional
tables would need to be parsed for ATSC.

It also doesn't current look inside the network descriptors to get
other transponders. So, on DVB-C, it will only get the channels
at the main frequency. I should fix it in a near future.

It is very likely that it will work as-is for DVB-T. 

If someone wants to patch the code to improve the tool, the descriptors
parser is inside descriptors.c file. The scan code that uses it is
at libscan.c. Finally, the data structure used by the scan parsing
is at libscan.h. The procedure is basicallt to add a new data field inside
the libscan.h structures, and then change the descriptors.c file
to fill it.

The main structure is this one:

struct dvb_descriptors {
        int verbose;

        struct pat_table pat_table;
        struct nit_table nit_table;
        struct sdt_table sdt_table;

        /* Used by descriptors to know where to update a PMT/Service/TS */
        unsigned cur_pmt;
        unsigned cur_service;
        unsigned cur_ts;
};

While parsing each table, the current item being parsed is pointed by
one of those unsigned values: cur_pmt, cur_service, cur_ts. Use this
to fill the data structure.

The dvb-file will likely need changes too, in order to write the
parsed information inside the channels file.

Patches are welcome!

Regards,
Mauro
