Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2AESfo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 13:35:44 -0500
Message-ID: <4F05ED78.2090701@redhat.com>
Date: Thu, 05 Jan 2012 16:35:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to
 one frontend
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com> <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com>
In-Reply-To: <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-01-2012 14:40, Devin Heitmueller wrote:
> On Thu, Jan 5, 2012 at 10:37 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> With all these series applied, it is now possible to use frontend 0
>> for all delivery systems. As the current tools don't support changing
>> the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
>> be used to change between them:
> 
> Hi Mauro,
> 
> While from a functional standpoint I think this is a good change (and
> we probably should have done it this way all along), is there not
> concern that this could be interpreted by regular users as a
> regression?  Right now they get two frontends, and they can use all
> their existing tools.  We're moving to a model where if users upgraded
> their kernel they would now require some new userland tool to do
> something that the kernel was allowing them to do previously.
> 
> Sure, it's not "ABI breakage" in the classic sense but the net effect
> is the same - stuff that used to work stops working and now they need
> new tools or to recompile their existing tools to include new
> functionality (which as you mentioned, none of those tools have
> today).
> 
> Perhaps you would consider some sort of module option that would let
> users fall back to the old behavior?

I see your point, but I can't see a simple way for fixing it. Thankfully,
there aren't many drivers yet that support multiple delivery systems
with different ops.info.type.

So, the better is to fix it earlier than later.

The issue with a fall-back option is that the end result will be the same:
it won't work as-is by default. The user will need to seek at the ML's
in order to discover about that. After discovering what is needed to fix
their environments, a simple tool that allows changing the delivery 
system at runtime  works better than a modprobe option to select it at
module load time, as it gives more flexibility to the user.

The real fix is to add support at the userspace applications for
using either the full DVBv5 API or, at least, to implement DTV_ENUM_DELSYS
and use a DVBv5 call to change the cache, on multi-frontend devices.

Btw, I just patched both my dvbv5-zap and dvbv5-scan applications to
work on that way.

Other GPL'd tools can just use my implementation as a reference if they
want, or write a simple code that will just add this on their code,
before checking if the delivery system matches their needs:

int set_delivery_system(uint32_t delivery_system)
{
	struct dtv_properties props;
	struct dtv_property dvb_prop[1];

       	dvb_prop[0].cmd = DTV_DELIVERY_SYSTEM;
	dvb_prop[0].u.data = delivery_system;
        props.num = 1;
        props.props = dvb_prop;
        if (ioctl(fd, FE_SET_PROPERTY, &props) >= 0
		return 0;
	return errno;
}

Regards,
Mauro

PS.: As a reference, the enclosed patch adds support for changing the
delivery system at the dvb-apps scan.c. Similar changes are needed at
the other dvb-apps tools.

--
scan: allow it to work with multiple delivery-systems frontends

Add support for changing the delivery system to the one specified
at the channels/transponders file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r bec11f78be51 util/scan/scan.c
--- a/util/scan/scan.c	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/scan.c	Thu Jan 05 15:28:14 2012 -0500
@@ -1934,14 +1934,54 @@
 	return -1;
 }
 
+static set_delivery_system(int fd, unsigned type)
+{
+	struct dtv_properties props;
+	struct dtv_property dvb_prop[1];
+	unsigned delsys;
+
+	switch (type) {
+		case FE_QPSK:
+			delsys = SYS_DVBS;
+			break;
+		case FE_QAM:
+			delsys = SYS_DVBC_ANNEX_AC;
+			break;
+		case FE_OFDM:
+			delsys = SYS_DVBT;
+			break;
+		case FE_ATSC:
+			delsys = SYS_ATSC;
+			break;
+		default:
+			return -1;
+	}
+
+	dvb_prop[0].cmd = DTV_DELIVERY_SYSTEM;
+	dvb_prop[0].u.data = delsys;
+	props.num = 1;
+	props.props = dvb_prop;
+	if (ioctl(fd, FE_SET_PROPERTY, &props) >= 0)
+		return 0;
+	return errno;
+}
+
 static int tune_to_transponder (int frontend_fd, struct transponder *t)
 {
+	int rc;
+
 	/* move TP from "new" to "scanned" list */
 	list_del_init(&t->list);
 	list_add_tail(&t->list, &scanned_transponders);
 	t->scan_done = 1;
 
 	if (t->type != fe_info.type) {
+		rc = set_delivery_system(frontend_fd, t->type);
+		if (!rc)
+			fe_info.type = t->type;
+	}
+
+	if (t->type != fe_info.type) {
 		warning("frontend type (%s) is not compatible with requested tuning type (%s)\n",
 				fe_type2str(fe_info.type),fe_type2str(t->type));
 		/* ignore cable descriptors in sat NIT and vice versa */

