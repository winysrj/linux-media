Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:53924 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbdGNJ3V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:29:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org
Subject: [PATCH 06/14] acpi: thermal: fix gcc-6/ccache warning
Date: Fri, 14 Jul 2017 11:25:18 +0200
Message-Id: <20170714092540.1217397-7-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In some configurations, topology_physical_package_id() is trivially
defined as '-1' for any input, resulting a comparison that is
always true:

drivers/acpi/processor_thermal.c: In function ‘cpufreq_set_cur_state’:
drivers/acpi/processor_thermal.c:137:36: error: self-comparison always evaluates to true [-Werror=tautological-compare]

By introducing a temporary variable, we can tell gcc that this is
intentional.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/acpi/processor_thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 59c3a5d1e600..411f3a7f4a7c 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -122,20 +122,22 @@ static int cpufreq_get_cur_state(unsigned int cpu)
 static int cpufreq_set_cur_state(unsigned int cpu, int state)
 {
 	int i;
+	int id;
 
 	if (!cpu_has_cpufreq(cpu))
 		return 0;
 
 	reduction_pctg(cpu) = state;
 
+	id = topology_physical_package_id(cpu);
+
 	/*
 	 * Update all the CPUs in the same package because they all
 	 * contribute to the temperature and often share the same
 	 * frequency.
 	 */
 	for_each_online_cpu(i) {
-		if (topology_physical_package_id(i) ==
-		    topology_physical_package_id(cpu))
+		if (topology_physical_package_id(i) == id)
 			cpufreq_update_policy(i);
 	}
 	return 0;
-- 
2.9.0
