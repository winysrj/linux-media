Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33121 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161882Ab2GMAA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 20:00:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=5D=20Documentation=3A=20DocBook=20DRM=20framework=20documentation?=
Date: Fri, 13 Jul 2012 02:00:23 +0200
Message-Id: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/drm.tmpl | 2835 +++++++++++++++++++++++++++++++---------
 1 files changed, 2226 insertions(+), 609 deletions(-)

Hi everybody,

Here's the DRM kernel framework documentation previously posted to the
dri-devel mailing list. The documentation has been reworked, converted to
DocBook and merged with the existing DocBook DRM documentation stub. The
result doesn't cover the whole DRM API but should hopefully be good enough
for a start.

I've done my best to follow a natural flow starting at initialization and
covering the major DRM internal topics. As I'm not a native English speaker
I'm not totally happy with the result, so if anyone wants to edit the text
please feel free to do so. Review will as usual be appreciated, and acks will
be even more welcome (I've been working on this document for longer than I
feel comfortable with).

diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
index 196b8b9..44a2c66 100644
--- a/Documentation/DocBook/drm.tmpl
+++ b/Documentation/DocBook/drm.tmpl
@@ -6,11 +6,36 @@
   <bookinfo>
     <title>Linux DRM Developer's Guide</title>
 
+    <authorgroup>
+      <author>
+	<firstname>Jesse</firstname>
+	<surname>Barnes</surname>
+	<contrib>Initial version</contrib>
+	<affiliation>
+	  <orgname>Intel Corporation</orgname>
+	  <address>
+	    <email>jesse.barnes@intel.com</email>
+	  </address>
+	</affiliation>
+      </author>
+      <author>
+	<firstname>Laurent</firstname>
+	<surname>Pinchart</surname>
+	<contrib>Driver internals</contrib>
+	<affiliation>
+	  <orgname>Ideas on board SPRL</orgname>
+	  <address>
+	    <email>laurent.pinchart@ideasonboard.com</email>
+	  </address>
+	</affiliation>
+      </author>
+    </authorgroup>
+
     <copyright>
       <year>2008-2009</year>
-      <holder>
-	Intel Corporation (Jesse Barnes &lt;jesse.barnes@intel.com&gt;)
-      </holder>
+      <year>2012</year>
+      <holder>Intel Corporation</holder>
+      <holder>Laurent Pinchart</holder>
     </copyright>
 
     <legalnotice>
@@ -20,6 +45,17 @@
 	the kernel source COPYING file.
       </para>
     </legalnotice>
+
+    <revhistory>
+      <!-- Put document revisions here, newest first. -->
+      <revision>
+	<revnumber>1.0</revnumber>
+	<date>2012-07-13</date>
+	<authorinitials>LP</authorinitials>
+	<revremark>Added extensive documentation about driver internals.
+	</revremark>
+      </revision>
+    </revhistory>
   </bookinfo>
 
 <toc></toc>
@@ -72,342 +108,361 @@
       submission &amp; fencing, suspend/resume support, and DMA
       services.
     </para>
-    <para>
-      The core of every DRM driver is struct drm_driver.  Drivers
-      typically statically initialize a drm_driver structure,
-      then pass it to drm_init() at load time.
-    </para>
 
   <!-- Internals: driver init -->
 
   <sect1>
-    <title>Driver initialization</title>
-    <para>
-      Before calling the DRM initialization routines, the driver must
-      first create and fill out a struct drm_driver structure.
-    </para>
-    <programlisting>
-      static struct drm_driver driver = {
-	/* Don't use MTRRs here; the Xserver or userspace app should
-	 * deal with them for Intel hardware.
-	 */
-	.driver_features =
-	    DRIVER_USE_AGP | DRIVER_REQUIRE_AGP |
-	    DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | DRIVER_MODESET,
-	.load = i915_driver_load,
-	.unload = i915_driver_unload,
-	.firstopen = i915_driver_firstopen,
-	.lastclose = i915_driver_lastclose,
-	.preclose = i915_driver_preclose,
-	.save = i915_save,
-	.restore = i915_restore,
-	.device_is_agp = i915_driver_device_is_agp,
-	.get_vblank_counter = i915_get_vblank_counter,
-	.enable_vblank = i915_enable_vblank,
-	.disable_vblank = i915_disable_vblank,
-	.irq_preinstall = i915_driver_irq_preinstall,
-	.irq_postinstall = i915_driver_irq_postinstall,
-	.irq_uninstall = i915_driver_irq_uninstall,
-	.irq_handler = i915_driver_irq_handler,
-	.reclaim_buffers = drm_core_reclaim_buffers,
-	.get_map_ofs = drm_core_get_map_ofs,
-	.get_reg_ofs = drm_core_get_reg_ofs,
-	.fb_probe = intelfb_probe,
-	.fb_remove = intelfb_remove,
-	.fb_resize = intelfb_resize,
-	.master_create = i915_master_create,
-	.master_destroy = i915_master_destroy,
-#if defined(CONFIG_DEBUG_FS)
-	.debugfs_init = i915_debugfs_init,
-	.debugfs_cleanup = i915_debugfs_cleanup,
-#endif
-	.gem_init_object = i915_gem_init_object,
-	.gem_free_object = i915_gem_free_object,
-	.gem_vm_ops = &amp;i915_gem_vm_ops,
-	.ioctls = i915_ioctls,
-	.fops = {
-		.owner = THIS_MODULE,
-		.open = drm_open,
-		.release = drm_release,
-		.ioctl = drm_ioctl,
-		.mmap = drm_mmap,
-		.poll = drm_poll,
-		.fasync = drm_fasync,
-#ifdef CONFIG_COMPAT
-		.compat_ioctl = i915_compat_ioctl,
-#endif
-		.llseek = noop_llseek,
-		},
-	.pci_driver = {
-		.name = DRIVER_NAME,
-		.id_table = pciidlist,
-		.probe = probe,
-		.remove = __devexit_p(drm_cleanup_pci),
-		},
-	.name = DRIVER_NAME,
-	.desc = DRIVER_DESC,
-	.date = DRIVER_DATE,
-	.major = DRIVER_MAJOR,
-	.minor = DRIVER_MINOR,
-	.patchlevel = DRIVER_PATCHLEVEL,
-      };
-    </programlisting>
-    <para>
-      In the example above, taken from the i915 DRM driver, the driver
-      sets several flags indicating what core features it supports;
-      we go over the individual callbacks in later sections.  Since
-      flags indicate which features your driver supports to the DRM
-      core, you need to set most of them prior to calling drm_init().  Some,
-      like DRIVER_MODESET can be set later based on user supplied parameters,
-      but that's the exception rather than the rule.
-    </para>
-    <variablelist>
-      <title>Driver flags</title>
-      <varlistentry>
-	<term>DRIVER_USE_AGP</term>
-	<listitem><para>
-	    Driver uses AGP interface
-	</para></listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_REQUIRE_AGP</term>
-	<listitem><para>
-	    Driver needs AGP interface to function.
-	</para></listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_USE_MTRR</term>
-	<listitem>
-	  <para>
-	    Driver uses MTRR interface for mapping memory.  Deprecated.
-	  </para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_PCI_DMA</term>
-	<listitem><para>
-	    Driver is capable of PCI DMA.  Deprecated.
-	</para></listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_SG</term>
-	<listitem><para>
-	    Driver can perform scatter/gather DMA.  Deprecated.
-	</para></listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_HAVE_DMA</term>
-	<listitem><para>Driver supports DMA.  Deprecated.</para></listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_HAVE_IRQ</term><term>DRIVER_IRQ_SHARED</term>
-	<listitem>
-	  <para>
-	    DRIVER_HAVE_IRQ indicates whether the driver has an IRQ
-	    handler.  DRIVER_IRQ_SHARED indicates whether the device &amp;
-	    handler support shared IRQs (note that this is required of
-	    PCI drivers).
-	  </para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_DMA_QUEUE</term>
-	<listitem>
-	  <para>
-	    Should be set if the driver queues DMA requests and completes them
-	    asynchronously.  Deprecated.
-	  </para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_FB_DMA</term>
-	<listitem>
-	  <para>
-	    Driver supports DMA to/from the framebuffer.  Deprecated.
-	  </para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term>DRIVER_MODESET</term>
-	<listitem>
-	  <para>
-	    Driver supports mode setting interfaces.
-	  </para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-    <para>
-      In this specific case, the driver requires AGP and supports
-      IRQs.  DMA, as discussed later, is handled by device-specific ioctls
-      in this case.  It also supports the kernel mode setting APIs, though
-      unlike in the actual i915 driver source, this example unconditionally
-      exports KMS capability.
+    <title>Driver Initialization</title>
+    <para>
+      At the core of every DRM driver is a <structname>drm_driver</structname>
+      structure. Drivers typically statically initialize a drm_driver structure,
+      and then pass it to one of the <function>drm_*_init()</function> functions
+      to register it with the DRM subsystem.
     </para>
-  </sect1>
-
-  <!-- Internals: driver load -->
-
-  <sect1>
-    <title>Driver load</title>
-    <para>
-      In the previous section, we saw what a typical drm_driver
-      structure might look like.  One of the more important fields in
-      the structure is the hook for the load function.
-    </para>
-    <programlisting>
-      static struct drm_driver driver = {
-      	...
-      	.load = i915_driver_load,
-        ...
-      };
-    </programlisting>
-    <para>
-      The load function has many responsibilities: allocating a driver
-      private structure, specifying supported performance counters,
-      configuring the device (e.g. mapping registers &amp; command
-      buffers), initializing the memory manager, and setting up the
-      initial output configuration.
-    </para>
-    <para>
-      If compatibility is a concern (e.g. with drivers converted over
-      to the new interfaces from the old ones), care must be taken to
-      prevent device initialization and control that is incompatible with
-      currently active userspace drivers.  For instance, if user
-      level mode setting drivers are in use, it would be problematic
-      to perform output discovery &amp; configuration at load time.
-      Likewise, if user-level drivers unaware of memory management are
-      in use, memory management and command buffer setup may need to
-      be omitted.  These requirements are driver-specific, and care
-      needs to be taken to keep both old and new applications and
-      libraries working.  The i915 driver supports the "modeset"
-      module parameter to control whether advanced features are
-      enabled at load time or in legacy fashion.
+    <para>
+      The <structname>drm_driver</structname> structure contains static
+      information that describe the driver and features it supports, and
+      pointers to methods that the DRM core will call to implement the DRM API.
+      We will first go through the <structname>drm_driver</structname> static
+      information fields, and will then describe individual operations in
+      details as they get used in later sections.
     </para>
-
     <sect2>
-      <title>Driver private &amp; performance counters</title>
-      <para>
-	The driver private hangs off the main drm_device structure and
-	can be used for tracking various device-specific bits of
-	information, like register offsets, command buffer status,
-	register state for suspend/resume, etc.  At load time, a
-	driver may simply allocate one and set drm_device.dev_priv
-	appropriately; it should be freed and drm_device.dev_priv set
-	to NULL when the driver is unloaded.
-      </para>
+      <title>Driver Information</title>
+      <sect3>
+        <title>Driver Features</title>
+        <para>
+          Drivers inform the DRM core about their requirements and supported
+          features by setting appropriate flags in the
+          <structfield>driver_features</structfield> field. Since those flags
+          influence the DRM core behaviour since registration time, most of them
+          must be set to registering the <structname>drm_driver</structname>
+          instance.
+        </para>
+        <synopsis>u32 driver_features;</synopsis>
+        <variablelist>
+          <title>Driver Feature Flags</title>
+          <varlistentry>
+            <term>DRIVER_USE_AGP</term>
+            <listitem><para>
+              Driver uses AGP interface, the DRM core will manage AGP resources.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_REQUIRE_AGP</term>
+            <listitem><para>
+              Driver needs AGP interface to function. AGP initialization failure
+              will become a fatal error.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_USE_MTRR</term>
+            <listitem><para>
+              Driver uses MTRR interface for mapping memory, the DRM core will
+              manage MTRR resources. Deprecated.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_PCI_DMA</term>
+            <listitem><para>
+              Driver is capable of PCI DMA, mapping of PCI DMA buffers to
+              userspace will be enabled. Deprecated.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_SG</term>
+            <listitem><para>
+              Driver can perform scatter/gather DMA, allocation and mapping of
+              scatter/gather buffers will be enabled. Deprecated.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_HAVE_DMA</term>
+            <listitem><para>
+              Driver supports DMA, the userspace DMA API will be supported.
+              Deprecated.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_HAVE_IRQ</term><term>DRIVER_IRQ_SHARED</term>
+            <listitem><para>
+              DRIVER_HAVE_IRQ indicates whether the driver has an IRQ handler. The
+              DRM core will automatically register an interrupt handler when the
+              flag is set. DRIVER_IRQ_SHARED indicates whether the device &amp;
+              handler support shared IRQs (note that this is required of PCI
+              drivers).
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_IRQ_VBL</term>
+            <listitem><para>Unused. Deprecated.</para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_DMA_QUEUE</term>
+            <listitem><para>
+              Should be set if the driver queues DMA requests and completes them
+              asynchronously.  Deprecated.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_FB_DMA</term>
+            <listitem><para>
+              Driver supports DMA to/from the framebuffer, mapping of frambuffer
+              DMA buffers to userspace will be supported. Deprecated.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_IRQ_VBL2</term>
+            <listitem><para>Unused. Deprecated.</para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_GEM</term>
+            <listitem><para>
+              Driver use the GEM memory manager.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_MODESET</term>
+            <listitem><para>
+              Driver supports mode setting interfaces (KMS).
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRIVER_PRIME</term>
+            <listitem><para>
+              Driver implements DRM PRIME buffer sharing.
+            </para></listitem>
+          </varlistentry>
+        </variablelist>
+      </sect3>
+      <sect3>
+        <title>Major, Minor and Patchlevel</title>
+        <synopsis>int major;
+  int minor;
+  int patchlevel;</synopsis>
+        <para>
+          The DRM core identifies driver versions by a major, minor and patch
+          level triplet. The information is printed to the kernel log at
+          initialization time and passed to userspace through the
+          DRM_IOCTL_VERSION ioctl.
+        </para>
+        <para>
+          The major and minor numbers are also used to verify the requested driver
+          API version passed to DRM_IOCTL_SET_VERSION. When the driver API changes
+          between minor versions, applications can call DRM_IOCTL_SET_VERSION to
+          select a specific version of the API. If the requested major isn't equal
+          to the driver major, or the requested minor is larger than the driver
+          minor, the DRM_IOCTL_SET_VERSION call will return an error. Otherwise
+          the driver's set_version() method will be called with the requested
+          version.
+        </para>
+      </sect3>
+      <sect3>
+        <title>Name, Description and Date</title>
+        <synopsis>char *name;
+  char *desc;
+  char *date;</synopsis>
+        <para>
+          The driver name is printed to the kernel log at initialization time,
+          used for IRQ registration and passed to userspace through
+          DRM_IOCTL_VERSION.
+        </para>
+        <para>
+          The driver description is a purely informative string passed to
+          userspace through the DRM_IOCTL_VERSION ioctl and otherwise unused by
+          the kernel.
+        </para>
+        <para>
+          The driver date, formatted as YYYYMMDD, is meant to identify the date of
+          the latest modification to the driver. However, as most drivers fail to
+          update it, its value is mostly useless. The DRM core prints it to the
+          kernel log at initialization time and passes it to userspace through the
+          DRM_IOCTL_VERSION ioctl.
+        </para>
+      </sect3>
+    </sect2>
+    <sect2>
+      <title>Driver Load</title>
       <para>
-	The DRM supports several counters which may be used for rough
-	performance characterization.  Note that the DRM stat counter
-	system is not often used by applications, and supporting
-	additional counters is completely optional.
+        The <methodname>load</methodname> method is the driver and device
+        initialization entry point. The method is responsible for allocating and
+        initializing driver private data, specifying supported performance
+        counters, performing resource allocation and mapping (e.g. acquiring
+        clocks, mapping registers or allocating command buffers), initializing
+        the memory manager (<xref linkend="drm-memory-management"/>), installing
+        the IRQ handler (<xref linkend="drm-irq-registration"/>), setting up
+        vertical blanking handling (<xref linkend="drm-vertical-blank"/>), mode
+	setting (<xref linkend="drm-mode-setting"/>) and initial output
+	configuration (<xref linkend="drm-kms-init"/>).
       </para>
+      <note><para>
+        If compatibility is a concern (e.g. with drivers converted over from
+        User Mode Setting to Kernel Mode Setting), care must be taken to prevent
+        device initialization and control that is incompatible with currently
+        active userspace drivers. For instance, if user level mode setting
+        drivers are in use, it would be problematic to perform output discovery
+        &amp; configuration at load time. Likewise, if user-level drivers
+        unaware of memory management are in use, memory management and command
+        buffer setup may need to be omitted. These requirements are
+        driver-specific, and care needs to be taken to keep both old and new
+        applications and libraries working.
+      </para></note>
+      <synopsis>int (*load) (struct drm_device *, unsigned long flags);</synopsis>
       <para>
-	These interfaces are deprecated and should not be used.  If performance
-	monitoring is desired, the developer should investigate and
-	potentially enhance the kernel perf and tracing infrastructure to export
-	GPU related performance information for consumption by performance
-	monitoring tools and applications.
+        The method takes two arguments, a pointer to the newly created
+	<structname>drm_device</structname> and flags. The flags are used to
+	pass the <structfield>driver_data</structfield> field of the device id
+	corresponding to the device passed to <function>drm_*_init()</function>.
+	Only PCI devices currently use this, USB and platform DRM drivers have
+	their <methodname>load</methodname> method called with flags to 0.
       </para>
+      <sect3>
+        <title>Driver Private &amp; Performance Counters</title>
+        <para>
+          The driver private hangs off the main
+          <structname>drm_device</structname> structure and can be used for
+          tracking various device-specific bits of information, like register
+          offsets, command buffer status, register state for suspend/resume, etc.
+          At load time, a driver may simply allocate one and set
+          <structname>drm_device</structname>.<structfield>dev_priv</structfield>
+          appropriately; it should be freed and
+          <structname>drm_device</structname>.<structfield>dev_priv</structfield>
+          set to NULL when the driver is unloaded.
+        </para>
+        <para>
+          DRM supports several counters which were used for rough performance
+          characterization. This stat counter system is deprecated and should not
+          be used. If performance monitoring is desired, the developer should
+          investigate and potentially enhance the kernel perf and tracing
+          infrastructure to export GPU related performance information for
+          consumption by performance monitoring tools and applications.
+        </para>
+      </sect3>
+      <sect3 id="drm-irq-registration">
+        <title>IRQ Registration</title>
+        <para>
+          The DRM core tries to facilitate IRQ handler registration and
+          unregistration by providing <function>drm_irq_install</function> and
+          <function>drm_irq_uninstall</function> functions. Those functions only
+          support a single interrupt per device.
+        </para>
+  <!--!Fdrivers/char/drm/drm_irq.c drm_irq_install-->
+        <para>
+          Both functions get the device IRQ by calling
+          <function>drm_dev_to_irq</function>. This inline function will call a
+          bus-specific operation to retrieve the IRQ number. For platform devices,
+          <function>platform_get_irq</function>(..., 0) is used to retrieve the
+          IRQ number.
+        </para>
+        <para>
+          <function>drm_irq_install</function> starts by calling the
+          <methodname>irq_preinstall</methodname> driver operation. The operation
+          is optional and must make sure that the interrupt will not get fired by
+          clearing all pending interrupt flags or disabling the interrupt.
+        </para>
+        <para>
+          The IRQ will then be requested by a call to
+          <function>request_irq</function>. If the DRIVER_IRQ_SHARED driver
+          feature flag is set, a shared (IRQF_SHARED) IRQ handler will be
+          requested.
+        </para>
+        <para>
+          The IRQ handler function must be provided as the mandatory irq_handler
+          driver operation. It will get passed directly to
+          <function>request_irq</function> and thus has the same prototype as all
+          IRQ handlers. It will get called with a pointer to the DRM device as the
+          second argument.
+        </para>
+        <para>
+          Finally the function calls the optional
+          <methodname>irq_postinstall</methodname> driver operation. The operation
+          usually enables interrupts (excluding the vblank interrupt, which is
+          enabled separately), but drivers may choose to enable/disable interrupts
+          at a different time.
+        </para>
+        <para>
+          <function>drm_irq_uninstall</function> is similarly used to uninstall an
+          IRQ handler. It starts by waking up all processes waiting on a vblank
+          interrupt to make sure they don't hang, and then calls the optional
+          <methodname>irq_uninstall</methodname> driver operation. The operation
+          must disable all hardware interrupts. Finally the function frees the IRQ
+          by calling <function>free_irq</function>.
+        </para>
+      </sect3>
+      <sect3>
+        <title>Memory Manager Initialization</title>
+        <para>
+          Every DRM driver requires a memory manager which must be initialized at
+          load time. DRM currently contains two memory managers, the Translation
+          Table Manager (TTM) and the Graphics Execution Manager (GEM).
+          This document describes the use of the GEM memory manager only. See
+          <xref linkend="drm-memory-management"/> for details.
+        </para>
+      </sect3>
+      <sect3>
+        <title>Miscellaneous Device Configuration</title>
+        <para>
+          Another task that may be necessary for PCI devices during configuration
+          is mapping the video BIOS. On many devices, the VBIOS describes device
+          configuration, LCD panel timings (if any), and contains flags indicating
+          device state. Mapping the BIOS can be done using the pci_map_rom() call,
+          a convenience function that takes care of mapping the actual ROM,
+          whether it has been shadowed into memory (typically at address 0xc0000)
+          or exists on the PCI device in the ROM BAR. Note that after the ROM has
+          been mapped and any necessary information has been extracted, it should
+          be unmapped; on many devices, the ROM address decoder is shared with
+          other BARs, so leaving it mapped could cause undesired behavior like
+          hangs or memory corruption.
+  <!--!Fdrivers/pci/rom.c pci_map_rom-->
+        </para>
+      </sect3>
     </sect2>
+  </sect1>
 
-    <sect2>
-      <title>Configuring the device</title>
-      <para>
-	Obviously, device configuration is device-specific.
-	However, there are several common operations: finding a
-	device's PCI resources, mapping them, and potentially setting
-	up an IRQ handler.
-      </para>
-      <para>
-	Finding &amp; mapping resources is fairly straightforward.  The
-	DRM wrapper functions, drm_get_resource_start() and
-	drm_get_resource_len(), may be used to find BARs on the given
-	drm_device struct.  Once those values have been retrieved, the
-	driver load function can call drm_addmap() to create a new
-	mapping for the BAR in question.  Note that you probably want a
-	drm_local_map_t in your driver private structure to track any
-	mappings you create.
-<!-- !Fdrivers/gpu/drm/drm_bufs.c drm_get_resource_* -->
-<!-- !Finclude/drm/drmP.h drm_local_map_t -->
-      </para>
-      <para>
-	if compatibility with other operating systems isn't a concern
-	(DRM drivers can run under various BSD variants and OpenSolaris),
-	native Linux calls may be used for the above, e.g. pci_resource_*
-	and iomap*/iounmap.  See the Linux device driver book for more
-	info.
-      </para>
-      <para>
-	Once you have a register map, you may use the DRM_READn() and
-	DRM_WRITEn() macros to access the registers on your device, or
-	use driver-specific versions to offset into your MMIO space
-	relative to a driver-specific base pointer (see I915_READ for
-	an example).
-      </para>
-      <para>
-	If your device supports interrupt generation, you may want to
-	set up an interrupt handler when the driver is loaded.  This
-	is done using the drm_irq_install() function.  If your device
-	supports vertical blank interrupts, it should call
-	drm_vblank_init() to initialize the core vblank handling code before
-	enabling interrupts on your device.  This ensures the vblank related
-	structures are allocated and allows the core to handle vblank events.
-      </para>
-<!--!Fdrivers/char/drm/drm_irq.c drm_irq_install-->
-      <para>
-	Once your interrupt handler is registered (it uses your
-	drm_driver.irq_handler as the actual interrupt handling
-	function), you can safely enable interrupts on your device,
-	assuming any other state your interrupt handler uses is also
-	initialized.
-      </para>
-      <para>
-	Another task that may be necessary during configuration is
-	mapping the video BIOS.  On many devices, the VBIOS describes
-	device configuration, LCD panel timings (if any), and contains
-	flags indicating device state.  Mapping the BIOS can be done
-	using the pci_map_rom() call, a convenience function that
-	takes care of mapping the actual ROM, whether it has been
-	shadowed into memory (typically at address 0xc0000) or exists
-	on the PCI device in the ROM BAR.  Note that after the ROM
-	has been mapped and any necessary information has been extracted,
-	it should be unmapped; on many devices, the ROM address decoder is
-	shared with other BARs, so leaving it mapped could cause
-	undesired behavior like hangs or memory corruption.
-<!--!Fdrivers/pci/rom.c pci_map_rom-->
-      </para>
-    </sect2>
+  <!-- Internals: memory management -->
 
+  <sect1 id="drm-memory-management">
+    <title>Memory management</title>
+    <para>
+      Modern Linux systems require large amount of graphics memory to store
+      frame buffers, textures, vertices and other graphics-related data. Given
+      the very dynamic nature of many of that data, managing graphics memory
+      efficiently is thus crucial for the graphics stack and plays a central
+      role in the DRM infrastructure.
+    </para>
+    <para>
+      The DRM core includes two memory managers, namely Translation Table Maps
+      (TTM) and Graphics Execution Manager (GEM). TTM was the first DRM memory
+      manager to be developed and tried to be a one-size-fits-them all
+      solution. It provides a single userspace API to accomodate the need of
+      all hardware, supporting both Unified Memory Architecture (UMA) devices
+      and devices with dedicated video RAM (i.e. most discrete video cards).
+      This resulted in a large, complex piece of code that turned out to be
+      hard to use for driver development.
+    </para>
+    <para>
+      GEM started as an Intel-sponsored project in reaction to TTM's
+      complexity. Its design philosophy is completely different: instead of
+      providing a solution to every graphics memory-related problems, GEM
+      identified common code between drivers and created a support library to
+      share it. GEM has simpler initialization and execution requirements than
+      TTM, but has no video RAM management capabitilies and is thus limited to
+      UMA devices.
+    </para>
     <sect2>
-      <title>Memory manager initialization</title>
-      <para>
-	In order to allocate command buffers, cursor memory, scanout
-	buffers, etc., as well as support the latest features provided
-	by packages like Mesa and the X.Org X server, your driver
-	should support a memory manager.
-      </para>
+      <title>The Translation Table Manager (TTM)</title>
       <para>
-	If your driver supports memory management (it should!), you
-	need to set that up at load time as well.  How you initialize
-	it depends on which memory manager you're using: TTM or GEM.
+	TTM design background and information belongs here.
       </para>
       <sect3>
 	<title>TTM initialization</title>
-	<para>
-	  TTM (for Translation Table Manager) manages video memory and
-	  aperture space for graphics devices. TTM supports both UMA devices
-	  and devices with dedicated video RAM (VRAM), i.e. most discrete
-	  graphics devices.  If your device has dedicated RAM, supporting
-	  TTM is desirable.  TTM also integrates tightly with your
-	  driver-specific buffer execution function.  See the radeon
-	  driver for examples.
-	</para>
-	<para>
-	  The core TTM structure is the ttm_bo_driver struct.  It contains
-	  several fields with function pointers for initializing the TTM,
-	  allocating and freeing memory, waiting for command completion
-	  and fence synchronization, and memory migration.  See the
-	  radeon_ttm.c file for an example of usage.
+        <warning><para>This section is outdated.</para></warning>
+        <para>
+          Drivers wishing to support TTM must fill out a drm_bo_driver
+          structure. The structure contains several fields with function
+          pointers for initializing the TTM, allocating and freeing memory,
+          waiting for command completion and fence synchronization, and memory
+          migration. See the radeon_ttm.c file for an example of usage.
 	</para>
 	<para>
 	  The ttm_global_reference structure is made up of several fields:
@@ -445,82 +500,1081 @@
 	  count for the TTM, which will call your initialization function.
 	</para>
       </sect3>
+    </sect2>
+    <sect2 id="drm-gem">
+      <title>The Graphics Execution Manager (GEM)</title>
+      <para>
+        The GEM design approach has resulted in a memory manager that doesn't
+        provide full coverage of all (or even all common) use cases in its
+        userspace or kernel API. GEM exposes a set of standard memory-related
+        operations to userspace and a set of helper functions to drivers, and let
+        drivers implement hardware-specific operations with their own private API.
+      </para>
+      <para>
+        The GEM userspace API is described in the
+        <ulink url="http://lwn.net/Articles/283798/"><citetitle>GEM - the Graphics
+        Execution Manager</citetitle></ulink> article on LWN. While slightly
+        outdated, the document provides a good overview of the GEM API principles.
+        Buffer allocation and read and write operations, described as part of the
+        common GEM API, are currently implemented using driver-specific ioctls.
+      </para>
+      <para>
+        GEM is data-agnostic. It manages abstract buffer objects without knowing
+        what individual buffers contain. APIs that require knowledge of buffer
+        contents or purpose, such as buffer allocation or synchronization
+        primitives, are thus outside of the scope of GEM and must be implemented
+        using driver-specific ioctls.
+      </para>
+      <para>
+	On a fundamental level, GEM involves several operations:
+	<itemizedlist>
+	  <listitem>Memory allocation and freeing</listitem>
+	  <listitem>Command execution</listitem>
+	  <listitem>Aperture management at command execution time</listitem>
+	</itemizedlist>
+	Buffer object allocation is relatively straightforward and largely
+        provided by Linux's shmem layer, which provides memory to back each
+        object.
+      </para>
+      <para>
+        Device-specific operations, such as command execution, pinning, buffer
+	read &amp; write, mapping, and domain ownership transfers are left to
+        driver-specific ioctls.
+      </para>
+      <sect3>
+        <title>GEM Initialization</title>
+        <para>
+          Drivers that use GEM must set the DRIVER_GEM bit in the struct
+          <structname>drm_driver</structname>
+          <structfield>driver_features</structfield> field. The DRM core will
+          then automatically initialize the GEM core before calling the
+          <methodname>load</methodname> operation. Behind the scene, this will
+          create a DRM Memory Manager object which provides an address space
+          pool for object allocation.
+        </para>
+        <para>
+          In a KMS configuration, drivers need to allocate and initialize a
+          command ring buffer following core GEM initialization if required by
+          the hardware. UMA devices usually have what is called a "stolen"
+          memory region, which provides space for the initial framebuffer and
+          large, contiguous memory regions required by the device. This space is
+          typically not managed by GEM, and must be initialized separately into
+          its own DRM MM object.
+        </para>
+      </sect3>
       <sect3>
-	<title>GEM initialization</title>
-	<para>
-	  GEM is an alternative to TTM, designed specifically for UMA
-	  devices.  It has simpler initialization and execution requirements
-	  than TTM, but has no VRAM management capability.  Core GEM
-	  is initialized by calling drm_mm_init() to create
-	  a GTT DRM MM object, which provides an address space pool for
-	  object allocation.  In a KMS configuration, the driver
-	  needs to allocate and initialize a command ring buffer following
-	  core GEM initialization.  A UMA device usually has what is called a
-	  "stolen" memory region, which provides space for the initial
-	  framebuffer and large, contiguous memory regions required by the
-	  device.  This space is not typically managed by GEM, and it must
-	  be initialized separately into its own DRM MM object.
-	</para>
-	<para>
-	  Initialization is driver-specific. In the case of Intel
-	  integrated graphics chips like 965GM, GEM initialization can
-	  be done by calling the internal GEM init function,
-	  i915_gem_do_init().  Since the 965GM is a UMA device
-	  (i.e. it doesn't have dedicated VRAM), GEM manages
-	  making regular RAM available for GPU operations.  Memory set
-	  aside by the BIOS (called "stolen" memory by the i915
-	  driver) is managed by the DRM memrange allocator; the
-	  rest of the aperture is managed by GEM.
-	  <programlisting>
-	    /* Basic memrange allocator for stolen space (aka vram) */
-	    drm_memrange_init(&amp;dev_priv->vram, 0, prealloc_size);
-	    /* Let GEM Manage from end of prealloc space to end of aperture */
-	    i915_gem_do_init(dev, prealloc_size, agp_size);
-	  </programlisting>
-<!--!Edrivers/char/drm/drm_memrange.c-->
-	</para>
-	<para>
-	  Once the memory manager has been set up, we may allocate the
-	  command buffer.  In the i915 case, this is also done with a
-	  GEM function, i915_gem_init_ringbuffer().
-	</para>
+        <title>GEM Objects Creation</title>
+        <para>
+          GEM splits creation of GEM objects and allocation of the memory that
+          backs them in two distinct operations.
+        </para>
+        <para>
+          GEM objects are represented by an instance of struct
+          <structname>drm_gem_object</structname>. Drivers usually need to extend
+          GEM objects with private information and thus create a driver-specific
+          GEM object structure type that embeds an instance of struct
+          <structname>drm_gem_object</structname>.
+        </para>
+        <para>
+          To create a GEM object, a driver allocates memory for an instance of its
+          specific GEM object type and initializes the embedded struct
+          <structname>drm_gem_object</structname> with a call to
+          <function>drm_gem_object_init</function>. The function takes a pointer to
+          the DRM device, a pointer to the GEM object and the buffer object size
+          in bytes.
+        </para>
+        <para>
+          GEM uses shmem to allocate anonymous pageable memory.
+          <function>drm_gem_object_init</function> will create an shmfs file of
+          the requested size and store it into the struct
+          <structname>drm_gem_object</structname> <structfield>filp</structfield>
+          field. The memory is used as either main storage for the object when the
+          graphics hardware uses system memory directly or as a backing store
+          otherwise.
+        </para>
+        <para>
+          Drivers are responsible for the actual physical pages allocation by
+          calling <function>shmem_read_mapping_page_gfp</function> for each page.
+          Note that they can decide to allocate pages when initializing the GEM
+          object, or to delay allocation until the memory is needed (for instance
+          when a page fault occurs as a result of a userspace memory access or
+          when the driver needs to start a DMA transfer involving the memory).
+        </para>
+        <para>
+          Anonymous pageable memory allocation is not always desired, for instance
+          when the hardware requires physically contiguous system memory as is
+          often the case in embedded devices. Drivers can create GEM objects with
+          no shmfs backing (called private GEM objects) by initializing them with
+          a call to <function>drm_gem_private_object_init</function> instead of
+          <function>drm_gem_object_init</function>. Storage for private GEM
+          objects must be managed by drivers.
+        </para>
+        <para>
+          Drivers that do not need to extend GEM objects with private information
+          can call the <function>drm_gem_object_alloc</function> function to
+          allocate and initialize a struct <structname>drm_gem_object</structname>
+          instance. The GEM core will call the optional driver
+          <methodname>gem_init_object</methodname> operation after initializing
+          the GEM object with <function>drm_gem_object_init</function>.
+          <synopsis>int (*gem_init_object) (struct drm_gem_object *obj);</synopsis>
+        </para>
+        <para>
+          No alloc-and-init function exists for private GEM objects.
+        </para>
+      </sect3>
+      <sect3>
+        <title>GEM Objects Lifetime</title>
+        <para>
+          All GEM objects are reference-counted by the GEM core. References can be
+          acquired and release by <function>calling drm_gem_object_reference</function>
+          and <function>drm_gem_object_unreference</function> respectively. The
+          caller must hold the <structname>drm_device</structname>
+          <structfield>struct_mutex</structfield> lock. As a convenience, GEM
+          provides the <function>drm_gem_object_reference_unlocked</function> and
+          <function>drm_gem_object_unreference_unlocked</function> functions that
+          can be called without holding the lock.
+        </para>
+        <para>
+          When the last reference to a GEM object is released the GEM core calls
+          the <structname>drm_driver</structname>
+          <methodname>gem_free_object</methodname> operation. That operation is
+          mandatory for GEM-enabled drivers and must free the GEM object and all
+          associated resources.
+        </para>
+        <para>
+          <synopsis>void (*gem_free_object) (struct drm_gem_object *obj);</synopsis>
+          Drivers are responsible for freeing all GEM object resources, including
+          the resources created by the GEM core. If an mmap offset has been
+          created for the object (in which case
+          <structname>drm_gem_object</structname>::<structfield>map_list</structfield>::<structfield>map</structfield>
+          is not NULL) it must be freed by a call to
+          <function>drm_gem_free_mmap_offset</function>. The shmfs backing store
+          must be released by calling <function>drm_gem_object_release</function>
+          (that function can safely be called if no shmfs backing store has been
+          created).
+        </para>
+      </sect3>
+      <sect3>
+        <title>GEM Objects Naming</title>
+        <para>
+          Communication between userspace and the kernel refers to GEM objects
+          using local handles, global names or, more recently, file descriptors.
+          All of those are 32-bit integer values; the usual Linux kernel limits
+          apply to the file descriptors.
+        </para>
+        <para>
+          GEM handles are local to a DRM file. Applications get a handle to a GEM
+          object through a driver-specific ioctl, and can use that handle to refer
+          to the GEM object in other standard or driver-specific ioctls. Closing a
+          DRM file handle frees all its GEM handles and dereferences the
+          associated GEM objects.
+        </para>
+        <para>
+          To create a handle for a GEM object drivers call
+          <function>drm_gem_handle_create</function>. The function takes a pointer
+          to the DRM file and the GEM object and returns a locally unique handle.
+          When the handle is no longer needed drivers delete it with a call to
+          <function>drm_gem_handle_delete</function>. Finally the GEM object
+          associated with a handle can be retrieved by a call to
+          <function>drm_gem_object_lookup</function>.
+        </para>
+        <para>
+          Handles don't take ownership of GEM objects, they only take a reference
+          to the object that will be dropped when the handle is destroyed. To
+          avoid leaking GEM objects, drivers must make sure they drop the
+          reference(s) they own (such as the initial reference taken at object
+          creation time) as appropriate, without any special consideration for the
+          handle. For example, in the particular case of combined GEM object and
+          handle creation in the implementation of the
+          <methodname>dumb_create</methodname> operation, drivers must drop the
+          initial reference to the GEM object before returning the handle.
+        </para>
+        <para>
+          GEM names are similar in purpose to handles but are not local to DRM
+          files. They can be passed between processes to reference a GEM object
+          globally. Names can't be used directly to refer to objects in the DRM
+          API, applications must convert handles to names and names to handles
+          using the DRM_IOCTL_GEM_FLINK and DRM_IOCTL_GEM_OPEN ioctls
+          respectively. The conversion is handled by the DRM core without any
+          driver-specific support.
+        </para>
+        <para>
+          Similar to global names, GEM file descriptors are also used to share GEM
+          objects across processes. They offer additional security: as file
+          descriptors must be explictly sent over UNIX domain sockets to be shared
+          between applications, they can't be guessed like the globally unique GEM
+          names.
+        </para>
+        <para>
+          Drivers that support GEM file descriptors, also known as the DRM PRIME
+          API, must set the DRIVER_PRIME bit in the struct
+          <structname>drm_driver</structname>
+          <structfield>driver_features</structfield> field, and implement the
+          <methodname>prime_handle_to_fd</methodname> and
+          <methodname>prime_fd_to_handle</methodname> operations.
+        </para>
+        <para>
+          <synopsis>int (*prime_handle_to_fd)(struct drm_device *dev,
+                            struct drm_file *file_priv, uint32_t handle,
+                            uint32_t flags, int *prime_fd);
+  int (*prime_fd_to_handle)(struct drm_device *dev,
+                            struct drm_file *file_priv, int prime_fd,
+                            uint32_t *handle);</synopsis>
+          Those two operations convert a handle to a PRIME file descriptor and
+          vice versa. Drivers must use the kernel dma-buf buffer sharing framework
+          to manage the PRIME file descriptors.
+        </para>
+        <para>
+          While non-GEM drivers must implement the operations themselves, GEM
+          drivers must use the <function>drm_gem_prime_handle_to_fd</function>
+          and <function>drm_gem_prime_fd_to_handle</function> helper functions.
+          Those helpers rely on the driver
+          <methodname>gem_prime_export</methodname> and
+          <methodname>gem_prime_import</methodname> operations to create a dma-buf
+          instance from a GEM object (dma-buf exporter role) and to create a GEM
+          object from a dma-buf instance (dma-buf importer role).
+        </para>
+        <para>
+          <synopsis>struct dma_buf * (*gem_prime_export)(struct drm_device *dev,
+                                       struct drm_gem_object *obj,
+                                       int flags);
+  struct drm_gem_object * (*gem_prime_import)(struct drm_device *dev,
+                                              struct dma_buf *dma_buf);</synopsis>
+          These two operations are mandatory for GEM drivers that support DRM
+          PRIME.
+        </para>
+      </sect3>
+      <sect3 id="drm-gem-objects-mapping">
+        <title>GEM Objects Mapping</title>
+        <para>
+          Because mapping operations are fairly heavyweight GEM favours
+          read/write-like access to buffers, implemented through driver-specific
+          ioctls, over mapping buffers to userspace. However, when random access
+          to the buffer is needed (to perform software rendering for instance),
+          direct access to the object can be more efficient.
+        </para>
+        <para>
+          The mmap system call can't be used directly to map GEM objects, as they
+          don't have their own file handle. Two alternative methods currently
+          co-exist to map GEM objects to userspace. The first method uses a
+          driver-specific ioctl to perform the mapping operation, calling
+          <function>do_mmap</function> under the hood. This is often considered
+          dubious, seems to be discouraged for new GEM-enabled drivers, and will
+          thus not be described here.
+        </para>
+        <para>
+          The second method uses the mmap system call on the DRM file handle.
+          <synopsis>void *mmap(void *addr, size_t length, int prot, int flags, int fd,
+             off_t offset);</synopsis>
+          DRM identifies the GEM object to be mapped by a fake offset passed
+          through the mmap offset argument. Prior to being mapped, a GEM object
+          must thus be associated with a fake offset. To do so, drivers must call
+          <function>drm_gem_create_mmap_offset</function> on the object. The
+          function allocates a fake offset range from a pool and stores the
+          offset divided by PAGE_SIZE in
+          <literal>obj-&gt;map_list.hash.key</literal>. Care must be taken not to
+          call <function>drm_gem_create_mmap_offset</function> if a fake offset
+          has already been allocated for the object. This can be tested by
+          <literal>obj-&gt;map_list.map</literal> being non-NULL.
+        </para>
+        <para>
+          Once allocated, the fake offset value
+          (<literal>obj-&gt;map_list.hash.key &lt;&lt; PAGE_SHIFT</literal>)
+          must be passed to the application in a driver-specific way and can then
+          be used as the mmap offset argument.
+        </para>
+        <para>
+          The GEM core provides a helper method <function>drm_gem_mmap</function>
+          to handle object mapping. The method can be set directly as the mmap
+          file operation handler. It will look up the GEM object based on the
+          offset value and set the VMA operations to the
+          <structname>drm_driver</structname> <structfield>gem_vm_ops</structfield>
+          field. Note that <function>drm_gem_mmap</function> doesn't map memory to
+          userspace, but relies on the driver-provided fault handler to map pages
+          individually.
+        </para>
+        <para>
+          To use <function>drm_gem_mmap</function>, drivers must fill the struct
+          <structname>drm_driver</structname> <structfield>gem_vm_ops</structfield>
+          field with a pointer to VM operations.
+        </para>
+        <para>
+          <synopsis>struct vm_operations_struct *gem_vm_ops
+
+  struct vm_operations_struct {
+          void (*open)(struct vm_area_struct * area);
+          void (*close)(struct vm_area_struct * area);
+          int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
+  };</synopsis>
+        </para>
+        <para>
+          The <methodname>open</methodname> and <methodname>close</methodname>
+          operations must update the GEM object reference count. Drivers can use
+          the <function>drm_gem_vm_open</function> and
+          <function>drm_gem_vm_close</function> helper functions directly as open
+          and close handlers.
+        </para>
+        <para>
+          The fault operation handler is responsible for mapping individual pages
+          to userspace when a page fault occurs. Depending on the memory
+          allocation scheme, drivers can allocate pages at fault time, or can
+          decide to allocate memory for the GEM object at the time the object is
+          created.
+        </para>
+        <para>
+          Drivers that want to map the GEM object upfront instead of handling page
+          faults can implement their own mmap file operation handler.
+        </para>
+      </sect3>
+      <sect3>
+        <title>Dumb GEM Objects</title>
+        <para>
+          The GEM API doesn't standardize GEM objects creation and leaves it to
+          driver-specific ioctls. While not an issue for full-fledged graphics
+          stacks that include device-specific userspace components (in libdrm for
+          instance), this limit makes DRM-based early boot graphics unnecessarily
+          complex.
+        </para>
+        <para>
+          Dumb GEM objects partly alleviate the problem by providing a standard
+          API to create dumb buffers suitable for scanout, which can then be used
+          to create KMS frame buffers.
+        </para>
+        <para>
+          To support dumb GEM objects drivers must implement the
+          <methodname>dumb_create</methodname>,
+          <methodname>dumb_destroy</methodname> and
+          <methodname>dumb_map_offset</methodname> operations.
+        </para>
+        <itemizedlist>
+          <listitem>
+            <synopsis>int (*dumb_create)(struct drm_file *file_priv, struct drm_device *dev,
+                     struct drm_mode_create_dumb *args);</synopsis>
+            <para>
+              The <methodname>dumb_create</methodname> operation creates a GEM
+              object suitable for scanout based on the width, height and depth
+              from the struct <structname>drm_mode_create_dumb</structname>
+              argument. It fills the argument's <structfield>handle</structfield>,
+              <structfield>pitch</structfield> and <structfield>size</structfield>
+              fields with a handle for the newly created GEM object and its line
+              pitch and size in bytes.
+            </para>
+          </listitem>
+          <listitem>
+            <synopsis>int (*dumb_destroy)(struct drm_file *file_priv, struct drm_device *dev,
+                      uint32_t handle);</synopsis>
+            <para>
+              The <methodname>dumb_destroy</methodname> operation destroys a dumb
+              GEM object created by <methodname>dumb_create</methodname>.
+            </para>
+          </listitem>
+          <listitem>
+            <synopsis>int (*dumb_map_offset)(struct drm_file *file_priv, struct drm_device *dev,
+                         uint32_t handle, uint64_t *offset);</synopsis>
+            <para>
+              The <methodname>dumb_map_offset</methodname> operation associates an
+              mmap fake offset with the GEM object given by the handle and returns
+              it. Drivers must use the
+              <function>drm_gem_create_mmap_offset</function> function to
+              associate the fake offset as described in
+              <xref linkend="drm-gem-objects-mapping"/>.
+            </para>
+          </listitem>
+        </itemizedlist>
+      </sect3>
+      <sect3>
+        <title>Memory Coherency</title>
+        <para>
+          When mapped to the device or used in a command buffer, backing pages
+          for an object are flushed to memory and marked write combined so as to
+          be coherent with the GPU. Likewise, if the CPU accesses an object
+          after the GPU has finished rendering to the object, then the object
+          must be made coherent with the CPU's view of memory, usually involving
+          GPU cache flushing of various kinds. This core CPU&lt;-&gt;GPU
+          coherency management is provided by a device-specific ioctl, which
+          evaluates an object's current domain and performs any necessary
+          flushing or synchronization to put the object into the desired
+          coherency domain (note that the object may be busy, i.e. an active
+          render target; in that case, setting the domain blocks the client and
+          waits for rendering to complete before performing any necessary
+          flushing operations).
+        </para>
+      </sect3>
+      <sect3>
+        <title>Command Execution</title>
+        <para>
+	  Perhaps the most important GEM function for GPU devices is providing a
+          command execution interface to clients. Client programs construct
+          command buffers containing references to previously allocated memory
+          objects, and then submit them to GEM. At that point, GEM takes care to
+          bind all the objects into the GTT, execute the buffer, and provide
+          necessary synchronization between clients accessing the same buffers.
+          This often involves evicting some objects from the GTT and re-binding
+          others (a fairly expensive operation), and providing relocation
+          support which hides fixed GTT offsets from clients. Clients must take
+          care not to submit command buffers that reference more objects than
+          can fit in the GTT; otherwise, GEM will reject them and no rendering
+          will occur. Similarly, if several objects in the buffer require fence
+          registers to be allocated for correct rendering (e.g. 2D blits on
+          pre-965 chips), care must be taken not to require more fence registers
+          than are available to the client. Such resource management should be
+          abstracted from the client in libdrm.
+        </para>
       </sect3>
     </sect2>
+  </sect1>
+
+  <!-- Internals: mode setting -->
 
+  <sect1 id="drm-mode-setting">
+    <title>Mode Setting</title>
+    <para>
+      Drivers must initialize the mode setting core by calling
+      <function>drm_mode_config_init</function> on the DRM device. The function
+      initializes the <structname>drm_device</structname>
+      <structfield>mode_config</structfield> field and never fails. Once done,
+      mode configuration must be setup by initializing the following fields.
+    </para>
+    <itemizedlist>
+      <listitem>
+        <synopsis>int min_width, min_height;
+int max_width, max_height;</synopsis>
+        <para>
+	  Minimum and maximum width and height of the frame buffers in pixel
+	  units.
+	</para>
+      </listitem>
+      <listitem>
+        <synopsis>struct drm_mode_config_funcs *funcs;</synopsis>
+	<para>Mode setting functions.</para>
+      </listitem>
+    </itemizedlist>
     <sect2>
-      <title>Output configuration</title>
+      <title>Frame Buffer Creation</title>
+      <synopsis>struct drm_framebuffer *(*fb_create)(struct drm_device *dev,
+				     struct drm_file *file_priv,
+				     struct drm_mode_fb_cmd2 *mode_cmd);</synopsis>
       <para>
-	The final initialization task is output configuration.  This involves:
-	<itemizedlist>
-	  <listitem>
-	    Finding and initializing the CRTCs, encoders, and connectors
-	    for the device.
-	  </listitem>
-	  <listitem>
-	    Creating an initial configuration.
-	  </listitem>
-	  <listitem>
-	    Registering a framebuffer console driver.
-	  </listitem>
-	</itemizedlist>
+        Frame buffers are abstract memory objects that provide a source of
+        pixels to scanout to a CRTC. Applications explicitly request the
+        creation of frame buffers through the DRM_IOCTL_MODE_ADDFB(2) ioctls and
+        receive an opaque handle that can be passed to the KMS CRTC control,
+        plane configuration and page flip functions.
+      </para>
+      <para>
+        Frame buffers rely on the underneath memory manager for low-level memory
+        operations. When creating a frame buffer applications pass a memory
+        handle (or a list of memory handles for multi-planar formats) through
+        the <parameter>drm_mode_fb_cmd2</parameter> argument. This document
+        assumes that the driver uses GEM, those handles thus reference GEM
+        objects.
+      </para>
+      <para>
+        Drivers must first validate the requested frame buffer parameters passed
+        through the mode_cmd argument. In particular this is where invalid
+        sizes, pixel formats or pitches can be caught.
+      </para>
+      <para>
+        If the parameters are deemed valid, drivers then create, initialize and
+        return an instance of struct <structname>drm_framebuffer</structname>.
+        If desired the instance can be embedded in a larger driver-specific
+        structure. The new instance is initialized with a call to
+        <function>drm_framebuffer_init</function> which takes a pointer to DRM
+        frame buffer operations (struct
+        <structname>drm_framebuffer_funcs</structname>). Frame buffer operations are
+        <itemizedlist>
+          <listitem>
+            <synopsis>int (*create_handle)(struct drm_framebuffer *fb,
+		     struct drm_file *file_priv, unsigned int *handle);</synopsis>
+            <para>
+              Create a handle to the frame buffer underlying memory object. If
+              the frame buffer uses a multi-plane format, the handle will
+              reference the memory object associated with the first plane.
+            </para>
+            <para>
+              Drivers call <function>drm_gem_handle_create</function> to create
+              the handle.
+            </para>
+          </listitem>
+          <listitem>
+            <synopsis>void (*destroy)(struct drm_framebuffer *framebuffer);</synopsis>
+            <para>
+              Destroy the frame buffer object and frees all associated
+              resources. Drivers must call
+              <function>drm_framebuffer_cleanup</function> to free resources
+              allocated by the DRM core for the frame buffer object, and must
+              make sure to unreference all memory objects associated with the
+              frame buffer. Handles created by the
+              <methodname>create_handle</methodname> operation are released by
+              the DRM core.
+            </para>
+          </listitem>
+          <listitem>
+            <synopsis>int (*dirty)(struct drm_framebuffer *framebuffer,
+	     struct drm_file *file_priv, unsigned flags, unsigned color,
+	     struct drm_clip_rect *clips, unsigned num_clips);</synopsis>
+            <para>
+              This optional operation notifies the driver that a region of the
+              frame buffer has changed in response to a DRM_IOCTL_MODE_DIRTYFB
+              ioctl call.
+            </para>
+          </listitem>
+        </itemizedlist>
+      </para>
+      <para>
+        After initializing the <structname>drm_framebuffer</structname>
+        instance drivers must fill its <structfield>width</structfield>,
+        <structfield>height</structfield>, <structfield>pitches</structfield>,
+        <structfield>offsets</structfield>, <structfield>depth</structfield>,
+        <structfield>bits_per_pixel</structfield> and
+        <structfield>pixel_format</structfield> fields from the values passed
+        through the <parameter>drm_mode_fb_cmd2</parameter> argument. They
+        should call the <function>drm_helper_mode_fill_fb_struct</function>
+        helper function to do so.
+      </para>
+    </sect2>
+    <sect2>
+      <title>Output Polling</title>
+      <synopsis>void (*output_poll_changed)(struct drm_device *dev);</synopsis>
+      <para>
+        This operation notifies the driver that the status of one or more
+        connectors has changed. Drivers that use the fbdev helper can just call
+        the <function>drm_fb_helper_hotplug_event</function> function to handle
+        this operation.
+      </para>
+    </sect2>
+  </sect1>
+
+  <!-- Internals: kms initialization and cleanup -->
+
+  <sect1 id="drm-kms-init">
+    <title>KMS Initialization and Cleanup</title>
+    <para>
+      A KMS device is abstracted and exposed as a set of planes, CRTCs, encoders
+      and connectors. KMS drivers must thus create and initialize all those
+      objects at load time after initializing mode setting.
+    </para>
+    <sect2>
+      <title>CRTCs (struct <structname>drm_crtc</structname>)</title>
+      <para>
+        A CRTC is an abstraction representing a part of the chip that contains a
+	pointer to a scanout buffer. Therefore, the number of CRTCs available
+	determines how many independent scanout buffers can be active at any
+	given time. The CRTC structure contains several fields to support this:
+	a pointer to some video memory (abstracted as a frame buffer object), a
+	display mode, and an (x, y) offset into the video memory to support
+	panning or configurations where one piece of video memory spans multiple
+	CRTCs.
       </para>
       <sect3>
-	<title>Output discovery and initialization</title>
-	<para>
-	  Several core functions exist to create CRTCs, encoders, and
-	  connectors, namely: drm_crtc_init(), drm_connector_init(), and
-	  drm_encoder_init(), along with several "helper" functions to
-	  perform common tasks.
-	</para>
-	<para>
-	  Connectors should be registered with sysfs once they've been
-	  detected and initialized, using the
-	  drm_sysfs_connector_add() function.  Likewise, when they're
-	  removed from the system, they should be destroyed with
-	  drm_sysfs_connector_remove().
-	</para>
-	<programlisting>
-<![CDATA[
+        <title>CRTC Initialization</title>
+        <para>
+          A KMS device must create and register at least one struct
+          <structname>drm_crtc</structname> instance. The instance is allocated
+          and zeroed by the driver, possibly as part of a larger structure, and
+          registered with a call to <function>drm_crtc_init</function> with a
+          pointer to CRTC functions.
+        </para>
+      </sect3>
+      <sect3>
+        <title>CRTC Operations</title>
+        <sect4>
+          <title>Set Configuration</title>
+          <synopsis>int (*set_config)(struct drm_mode_set *set);</synopsis>
+          <para>
+            Apply a new CRTC configuration to the device. The configuration
+            specifies a CRTC, a frame buffer to scan out from, a (x,y) position in
+            the frame buffer, a display mode and an array of connectors to drive
+            with the CRTC if possible.
+          </para>
+          <para>
+            If the frame buffer specified in the configuration is NULL, the driver
+            must detach all encoders connected to the CRTC and all connectors
+            attached to those encoders and disable them.
+          </para>
+          <para>
+            This operation is called with the mode config lock held.
+          </para>
+          <note><para>
+            FIXME: How should set_config interact with DPMS? If the CRTC is
+            suspended, should it be resumed?
+          </para></note>
+        </sect4>
+        <sect4>
+          <title>Page Flipping</title>
+          <synopsis>int (*page_flip)(struct drm_crtc *crtc, struct drm_framebuffer *fb,
+                   struct drm_pending_vblank_event *event);</synopsis>
+          <para>
+            Schedule a page flip to the given frame buffer for the CRTC. This
+            operation is called with the mode config mutex held.
+          </para>
+          <para>
+            Page flipping is a synchronization mechanism that replaces the frame
+            buffer being scanned out by the CRTC with a new frame buffer during
+            vertical blanking, avoiding tearing. When an application requests a page
+            flip the DRM core verifies that the new frame buffer is large enough to
+            be scanned out by  the CRTC in the currently configured mode and then
+            calls the CRTC <methodname>page_flip</methodname> operation with a
+            pointer to the new frame buffer.
+          </para>
+          <para>
+            The <methodname>page_flip</methodname> operation schedules a page flip.
+            Once any pending rendering targetting the new frame buffer has
+            completed, the CRTC will be reprogrammed to display that frame buffer
+            after the next vertical refresh. The operation must return immediately
+            without waiting for rendering or page flip to complete and must block
+            any new rendering to the frame buffer until the page flip completes.
+          </para>
+          <para>
+            If a page flip is already pending, the
+            <methodname>page_flip</methodname> operation must return
+            -<errorname>EBUSY</errorname>.
+          </para>
+          <para>
+            To synchronize page flip to vertical blanking the driver will likely
+            need to enable vertical blanking interrupts. It should call
+            <function>drm_vblank_get</function> for that purpose, and call
+            <function>drm_vblank_put</function> after the page flip completes.
+          </para>
+          <para>
+            If the application has requested to be notified when page flip completes
+            the <methodname>page_flip</methodname> operation will be called with a
+            non-NULL <parameter>event</parameter> argument pointing to a
+            <structname>drm_pending_vblank_event</structname> instance. Upon page
+            flip completion the driver must fill the
+            <parameter>event</parameter>::<structfield>event</structfield>
+            <structfield>sequence</structfield>, <structfield>tv_sec</structfield>
+            and <structfield>tv_usec</structfield> fields with the associated
+            vertical blanking count and timestamp, add the event to the
+            <parameter>drm_file</parameter> list of events to be signaled, and wake
+            up any waiting process. This can be performed with
+            <programlisting><![CDATA[
+            struct timeval now;
+
+            event->event.sequence = drm_vblank_count_and_time(..., &now);
+            event->event.tv_sec = now.tv_sec;
+            event->event.tv_usec = now.tv_usec;
+
+            spin_lock_irqsave(&dev->event_lock, flags);
+            list_add_tail(&event->base.link, &event->base.file_priv->event_list);
+            wake_up_interruptible(&event->base.file_priv->event_wait);
+            spin_unlock_irqrestore(&dev->event_lock, flags);
+            ]]></programlisting>
+          </para>
+          <note><para>
+            FIXME: Could drivers that don't need to wait for rendering to complete
+            just add the event to <literal>dev-&gt;vblank_event_list</literal> and
+            let the DRM core handle everything, as for "normal" vertical blanking
+            events?
+          </para></note>
+          <para>
+            While waiting for the page flip to complete, the
+            <literal>event-&gt;base.link</literal> list head can be used freely by
+            the driver to store the pending event in a driver-specific list.
+          </para>
+          <para>
+            If the file handle is closed before the event is signaled, drivers must
+            take care to destroy the event in their
+            <methodname>preclose</methodname> operation (and, if needed, call
+            <function>drm_vblank_put</function>).
+          </para>
+        </sect4>
+        <sect4>
+          <title>Miscellaneous</title>
+          <itemizedlist>
+            <listitem>
+              <synopsis>void (*gamma_set)(struct drm_crtc *crtc, u16 *r, u16 *g, u16 *b,
+                        uint32_t start, uint32_t size);</synopsis>
+              <para>
+                Apply a gamma table to the device. The operation is optional.
+              </para>
+            </listitem>
+            <listitem>
+              <synopsis>void (*destroy)(struct drm_crtc *crtc);</synopsis>
+              <para>
+                Destroy the CRTC when not needed anymore. See
+                <xref linkend="drm-kms-init"/>.
+              </para>
+            </listitem>
+          </itemizedlist>
+        </sect4>
+      </sect3>
+    </sect2>
+    <sect2>
+      <title>Planes (struct <structname>drm_plane</structname>)</title>
+      <para>
+        A plane represents an image source that can be blended with or overlayed
+	on top of a CRTC during the scanout process. Planes are associated with
+	a frame buffer to crop a portion of the image memory (source) and
+	optionally scale it to a destination size. The result is then blended
+	with or overlayed on top of a CRTC.
+      </para>
+      <sect3>
+        <title>Plane Initialization</title>
+        <para>
+          Planes are optional. To create a plane, a KMS drivers allocates and
+          zeroes an instances of struct <structname>drm_plane</structname>
+          (possibly as part of a larger structure) and registers it with a call
+          to <function>drm_plane_init</function>. The function takes a bitmask
+          of the CRTCs that can be associated with the plane, a pointer to the
+          plane functions and a list of format supported formats.
+        </para>
+      </sect3>
+      <sect3>
+        <title>Plane Operations</title>
+        <itemizedlist>
+          <listitem>
+            <synopsis>int (*update_plane)(struct drm_plane *plane, struct drm_crtc *crtc,
+                        struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+                        unsigned int crtc_w, unsigned int crtc_h,
+                        uint32_t src_x, uint32_t src_y,
+                        uint32_t src_w, uint32_t src_h);</synopsis>
+            <para>
+              Enable and configure the plane to use the given CRTC and frame buffer.
+            </para>
+            <para>
+              The source rectangle in frame buffer memory coordinates is given by
+              the <parameter>src_x</parameter>, <parameter>src_y</parameter>,
+              <parameter>src_w</parameter> and <parameter>src_h</parameter>
+              parameters (as 16.16 fixed point values). Devices that don't support
+              subpixel plane coordinates can ignore the fractional part.
+            </para>
+            <para>
+              The destination rectangle in CRTC coordinates is given by the
+              <parameter>crtc_x</parameter>, <parameter>crtc_y</parameter>,
+              <parameter>crtc_w</parameter> and <parameter>crtc_h</parameter>
+              parameters (as integer values). Devices scale the source rectangle to
+              the destination rectangle. If scaling is not supported, and the source
+              rectangle size doesn't match the destination rectangle size, the
+              driver must return a -<errorname>EINVAL</errorname> error.
+            </para>
+          </listitem>
+          <listitem>
+            <synopsis>int (*disable_plane)(struct drm_plane *plane);</synopsis>
+            <para>
+              Disable the plane. The DRM core calls this method in response to a
+              DRM_IOCTL_MODE_SETPLANE ioctl call with the frame buffer ID set to 0.
+              Disabled planes must not be processed by the CRTC.
+            </para>
+          </listitem>
+          <listitem>
+            <synopsis>void (*destroy)(struct drm_plane *plane);</synopsis>
+            <para>
+              Destroy the plane when not needed anymore. See
+              <xref linkend="drm-kms-init"/>.
+            </para>
+          </listitem>
+        </itemizedlist>
+      </sect3>
+    </sect2>
+    <sect2>
+      <title>Encoders (struct <structname>drm_encoder</structname>)</title>
+      <para>
+        An encoder takes pixel data from a CRTC and converts it to a format
+	suitable for any attached connectors. On some devices, it may be
+	possible to have a CRTC send data to more than one encoder. In that
+	case, both encoders would receive data from the same scanout buffer,
+	resulting in a "cloned" display configuration across the connectors
+	attached to each encoder.
+      </para>
+      <sect3>
+        <title>Encoder Initialization</title>
+        <para>
+          As for CRTCs, a KMS driver must create, initialize and register at
+          least one struct <structname>drm_encoder</structname> instance. The
+          instance is allocated and zeroed by the driver, possibly as part of a
+          larger structure.
+        </para>
+        <para>
+          Drivers must initialize the struct <structname>drm_encoder</structname>
+          <structfield>possible_crtcs</structfield> and
+          <structfield>possible_clones</structfield> fields before registering the
+          encoder. Both fields are bitmasks of respectively the CRTCs that the
+          encoder can be connected to, and sibling encoders candidate for cloning.
+        </para>
+        <para>
+          After being initialized, the encoder must be registered with a call to
+          <function>drm_encoder_init</function>. The function takes a pointer to
+          the encoder functions and an encoder type. Supported types are
+          <itemizedlist>
+            <listitem>
+              DRM_MODE_ENCODER_DAC for VGA and analog on DVI-I/DVI-A
+              </listitem>
+            <listitem>
+              DRM_MODE_ENCODER_TMDS for DVI, HDMI and (embedded) DisplayPort
+            </listitem>
+            <listitem>
+              DRM_MODE_ENCODER_LVDS for display panels
+            </listitem>
+            <listitem>
+              DRM_MODE_ENCODER_TVDAC for TV output (Composite, S-Video, Component,
+              SCART)
+            </listitem>
+            <listitem>
+              DRM_MODE_ENCODER_VIRTUAL for virtual machine displays
+            </listitem>
+          </itemizedlist>
+        </para>
+        <para>
+          Encoders must be attached to a CRTC to be used. DRM drivers leave
+          encoders unattached at initialization time. Applications (or the fbdev
+          compatibility layer when implemented) are responsible for attaching the
+          encoders they want to use to a CRTC.
+        </para>
+      </sect3>
+      <sect3>
+        <title>Encoder Operations</title>
+        <itemizedlist>
+          <listitem>
+            <synopsis>void (*destroy)(struct drm_encoder *encoder);</synopsis>
+            <para>
+              Called to destroy the encoder when not needed anymore. See
+              <xref linkend="drm-kms-init"/>.
+            </para>
+          </listitem>
+        </itemizedlist>
+      </sect3>
+    </sect2>
+    <sect2>
+      <title>Connectors (struct <structname>drm_connector</structname>)</title>
+      <para>
+        A connector is the final destination for pixel data on a device, and
+	usually connects directly to an external display device like a monitor
+	or laptop panel. A connector can only be attached to one encoder at a
+	time. The connector is also the structure where information about the
+	attached display is kept, so it contains fields for display data, EDID
+	data, DPMS &amp; connection status, and information about modes
+	supported on the attached displays.
+      </para>
+      <sect3>
+        <title>Connector Initialization</title>
+        <para>
+          Finally a KMS driver must create, initialize, register and attach at
+          least one struct <structname>drm_connector</structname> instance. The
+          instance is created as other KMS objects and initialized by setting the
+          following fields.
+        </para>
+        <variablelist>
+          <varlistentry>
+            <term><structfield>interlace_allowed</structfield></term>
+            <listitem><para>
+              Whether the connector can handle interlaced modes.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term><structfield>doublescan_allowed</structfield></term>
+            <listitem><para>
+              Whether the connector can handle doublescan.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term><structfield>display_info
+            </structfield></term>
+            <listitem><para>
+              Display information is filled from EDID information when a display
+              is detected. For non hot-pluggable displays such as flat panels in
+              embedded systems, the driver should initialize the
+              <structfield>display_info</structfield>.<structfield>width_mm</structfield>
+              and
+              <structfield>display_info</structfield>.<structfield>height_mm</structfield>
+              fields with the physical size of the display.
+            </para></listitem>
+          </varlistentry>
+          <varlistentry>
+            <term id="drm-kms-connector-polled"><structfield>polled</structfield></term>
+            <listitem><para>
+              Connector polling mode, a combination of
+              <variablelist>
+                <varlistentry>
+                  <term>DRM_CONNECTOR_POLL_HPD</term>
+                  <listitem><para>
+                    The connector generates hotplug events and doesn't need to be
+                    periodically polled. The CONNECT and DISCONNECT flags must not
+                    be set together with the HPD flag.
+                  </para></listitem>
+                </varlistentry>
+                <varlistentry>
+                  <term>DRM_CONNECTOR_POLL_CONNECT</term>
+                  <listitem><para>
+                    Periodically poll the connector for connection.
+                  </para></listitem>
+                </varlistentry>
+                <varlistentry>
+                  <term>DRM_CONNECTOR_POLL_DISCONNECT</term>
+                  <listitem><para>
+                    Periodically poll the connector for disconnection.
+                  </para></listitem>
+                </varlistentry>
+              </variablelist>
+              Set to 0 for connectors that don't support connection status
+              discovery.
+            </para></listitem>
+          </varlistentry>
+        </variablelist>
+        <para>
+          The connector is then registered with a call to
+          <function>drm_connector_init</function> with a pointer to the connector
+          functions and a connector type, and exposed through sysfs with a call to
+          <function>drm_sysfs_connector_add</function>.
+        </para>
+        <para>
+          Supported connector types are
+          <itemizedlist>
+            <listitem>DRM_MODE_CONNECTOR_VGA</listitem>
+            <listitem>DRM_MODE_CONNECTOR_DVII</listitem>
+            <listitem>DRM_MODE_CONNECTOR_DVID</listitem>
+            <listitem>DRM_MODE_CONNECTOR_DVIA</listitem>
+            <listitem>DRM_MODE_CONNECTOR_Composite</listitem>
+            <listitem>DRM_MODE_CONNECTOR_SVIDEO</listitem>
+            <listitem>DRM_MODE_CONNECTOR_LVDS</listitem>
+            <listitem>DRM_MODE_CONNECTOR_Component</listitem>
+            <listitem>DRM_MODE_CONNECTOR_9PinDIN</listitem>
+            <listitem>DRM_MODE_CONNECTOR_DisplayPort</listitem>
+            <listitem>DRM_MODE_CONNECTOR_HDMIA</listitem>
+            <listitem>DRM_MODE_CONNECTOR_HDMIB</listitem>
+            <listitem>DRM_MODE_CONNECTOR_TV</listitem>
+            <listitem>DRM_MODE_CONNECTOR_eDP</listitem>
+            <listitem>DRM_MODE_CONNECTOR_VIRTUAL</listitem>
+          </itemizedlist>
+        </para>
+        <para>
+          Connectors must be attached to an encoder to be used. For devices that
+          map connectors to encoders 1:1, the connector should be attached at
+          initialization time with a call to
+          <function>drm_mode_connector_attach_encoder</function>. The driver must
+          also set the <structname>drm_connector</structname>
+          <structfield>encoder</structfield> field to point to the attached
+          encoder.
+        </para>
+        <para>
+          Finally, drivers must initialize the connectors state change detection
+          with a call to <function>drm_kms_helper_poll_init</function>. If at
+          least one connector is pollable but can't generate hotplug interrupts
+          (indicated by the DRM_CONNECTOR_POLL_CONNECT and
+          DRM_CONNECTOR_POLL_DISCONNECT connector flags), a delayed work will
+          automatically be queued to periodically poll for changes. Connectors
+          that can generate hotplug interrupts must be marked with the
+          DRM_CONNECTOR_POLL_HPD flag instead, and their interrupt handler must
+          call <function>drm_helper_hpd_irq_event</function>. The function will
+          queue a delayed work to check the state of all connectors, but no
+          periodic polling will be done.
+        </para>
+      </sect3>
+      <sect3>
+        <title>Connector Operations</title>
+        <note><para>
+          Unless otherwise state, all operations are mandatory.
+        </para></note>
+        <sect4>
+          <title>DPMS</title>
+          <synopsis>void (*dpms)(struct drm_connector *connector, int mode);</synopsis>
+          <para>
+            The DPMS operation sets the power state of a connector. The mode
+            argument is one of
+            <itemizedlist>
+              <listitem><para>DRM_MODE_DPMS_ON</para></listitem>
+              <listitem><para>DRM_MODE_DPMS_STANDBY</para></listitem>
+              <listitem><para>DRM_MODE_DPMS_SUSPEND</para></listitem>
+              <listitem><para>DRM_MODE_DPMS_OFF</para></listitem>
+            </itemizedlist>
+          </para>
+          <para>
+            In all but DPMS_ON mode the encoder to which the connector is attached
+            should put the display in low-power mode by driving its signals
+            appropriately. If more than one connector is attached to the encoder
+            care should be taken not to change the power state of other displays as
+            a side effect. Low-power mode should be propagated to the encoders and
+            CRTCs when all related connectors are put in low-power mode.
+          </para>
+        </sect4>
+        <sect4>
+          <title>Modes</title>
+          <synopsis>int (*fill_modes)(struct drm_connector *connector, uint32_t max_width,
+                      uint32_t max_height);</synopsis>
+          <para>
+            Fill the mode list with all supported modes for the connector. If the
+            <parameter>max_width</parameter> and <parameter>max_height</parameter>
+            arguments are non-zero, the implementation must ignore all modes wider
+            than <parameter>max_width</parameter> or higher than
+            <parameter>max_height</parameter>.
+          </para>
+          <para>
+            The connector must also fill in this operation its
+            <structfield>display_info</structfield>
+            <structfield>width_mm</structfield> and
+            <structfield>height_mm</structfield> fields with the connected display
+            physical size in millimeters. The fields should be set to 0 if the value
+            isn't known or is not applicable (for instance for projector devices).
+          </para>
+        </sect4>
+        <sect4>
+          <title>Connection Status</title>
+          <para>
+            The connection status is updated through polling or hotplug events when
+            supported (see <xref linkend="drm-kms-connector-polled"/>). The status
+            value is reported to userspace through ioctls and must not be used
+            inside the driver, as it only gets initialized by a call to
+            <function>drm_mode_getconnector</function> from userspace.
+          </para>
+          <synopsis>enum drm_connector_status (*detect)(struct drm_connector *connector,
+                                        bool force);</synopsis>
+          <para>
+            Check to see if anything is attached to the connector. The
+            <parameter>force</parameter> parameter is set to false whilst polling or
+            to true when checking the connector due to user request.
+            <parameter>force</parameter> can be used by the driver to avoid
+            expensive, destructive operations during automated probing.
+          </para>
+          <para>
+            Return connector_status_connected if something is connected to the
+            connector, connector_status_disconnected if nothing is connected and
+            connector_status_unknown if the connection state isn't known.
+          </para>
+          <para>
+            Drivers should only return connector_status_connected if the connection
+            status has really been probed as connected. Connectors that can't detect
+            the connection status, or failed connection status probes, should return
+            connector_status_unknown.
+          </para>
+        </sect4>
+        <sect4>
+          <title>Miscellaneous</title>
+          <itemizedlist>
+            <listitem>
+              <synopsis>void (*destroy)(struct drm_connector *connector);</synopsis>
+              <para>
+                Destroy the connector when not needed anymore. See
+                <xref linkend="drm-kms-init"/>.
+              </para>
+            </listitem>
+          </itemizedlist>
+        </sect4>
+      </sect3>
+    </sect2>
+    <sect2>
+      <title>Cleanup</title>
+      <para>
+        The DRM core manages its objects' lifetime. When an object is not needed
+	anymore the core calls its destroy function, which must clean up and
+	free every resource allocated for the object. Every
+	<function>drm_*_init</function> call must be matched with a
+	corresponding <function>drm_*_cleanup</function> call to cleanup CRTCs
+	(<function>drm_crtc_cleanup</function>), planes
+	(<function>drm_plane_cleanup</function>), encoders
+	(<function>drm_encoder_cleanup</function>) and connectors
+	(<function>drm_connector_cleanup</function>). Furthermore, connectors
+	that have been added to sysfs must be removed by a call to
+	<function>drm_sysfs_connector_remove</function> before calling
+	<function>drm_connector_cleanup</function>.
+      </para>
+      <para>
+        Connectors state change detection must be cleanup up with a call to
+	<function>drm_kms_helper_poll_fini</function>.
+      </para>
+    </sect2>
+    <sect2>
+      <title>Output discovery and initialization example</title>
+      <programlisting><![CDATA[
 void intel_crt_init(struct drm_device *dev)
 {
 	struct drm_connector *connector;
@@ -556,252 +1610,741 @@ void intel_crt_init(struct drm_device *dev)
 	drm_connector_helper_add(connector, &intel_crt_connector_helper_funcs);
 
 	drm_sysfs_connector_add(connector);
-}
-]]>
-	</programlisting>
-	<para>
-	  In the example above (again, taken from the i915 driver), a
-	  CRT connector and encoder combination is created.  A device-specific
-	  i2c bus is also created for fetching EDID data and
-	  performing monitor detection.  Once the process is complete,
-	  the new connector is registered with sysfs to make its
-	  properties available to applications.
-	</para>
-	<sect4>
-	  <title>Helper functions and core functions</title>
-	  <para>
-	    Since many PC-class graphics devices have similar display output
-	    designs, the DRM provides a set of helper functions to make
-	    output management easier.  The core helper routines handle
-	    encoder re-routing and the disabling of unused functions following
-	    mode setting.  Using the helpers is optional, but recommended for
-	    devices with PC-style architectures (i.e. a set of display planes
-	    for feeding pixels to encoders which are in turn routed to
-	    connectors).  Devices with more complex requirements needing
-	    finer grained management may opt to use the core callbacks
-	    directly.
-	  </para>
-	  <para>
-	    [Insert typical diagram here.]  [Insert OMAP style config here.]
-	  </para>
-	</sect4>
-	<para>
-	  Each encoder object needs to provide:
-	  <itemizedlist>
-	    <listitem>
-	      A DPMS (basically on/off) function.
-	    </listitem>
-	    <listitem>
-	      A mode-fixup function (for converting requested modes into
-	      native hardware timings).
-	    </listitem>
-	    <listitem>
-	      Functions (prepare, set, and commit) for use by the core DRM
-	      helper functions.
-	    </listitem>
-	  </itemizedlist>
-	  Connector helpers need to provide functions (mode-fetch, validity,
-	  and encoder-matching) for returning an ideal encoder for a given
-	  connector.  The core connector functions include a DPMS callback,
-	  save/restore routines (deprecated), detection, mode probing,
-	  property handling, and cleanup functions.
-	</para>
-<!--!Edrivers/char/drm/drm_crtc.h-->
-<!--!Edrivers/char/drm/drm_crtc.c-->
-<!--!Edrivers/char/drm/drm_crtc_helper.c-->
-      </sect3>
+}]]></programlisting>
+      <para>
+        In the example above (taken from the i915 driver), a CRTC, connector and
+        encoder combination is created. A device-specific i2c bus is also
+        created for fetching EDID data and performing monitor detection. Once
+        the process is complete, the new connector is registered with sysfs to
+        make its properties available to applications.
+      </para>
     </sect2>
   </sect1>
 
-  <!-- Internals: vblank handling -->
+  <!-- Internals: mid-layer helper functions -->
 
   <sect1>
-    <title>VBlank event handling</title>
+    <title>Mid-layer Helper Functions</title>
     <para>
-      The DRM core exposes two vertical blank related ioctls:
-      <variablelist>
-        <varlistentry>
-          <term>DRM_IOCTL_WAIT_VBLANK</term>
-          <listitem>
-            <para>
-              This takes a struct drm_wait_vblank structure as its argument,
-              and it is used to block or request a signal when a specified
-              vblank event occurs.
-            </para>
-          </listitem>
-        </varlistentry>
-        <varlistentry>
-          <term>DRM_IOCTL_MODESET_CTL</term>
-          <listitem>
-            <para>
-              This should be called by application level drivers before and
-              after mode setting, since on many devices the vertical blank
-              counter is reset at that time.  Internally, the DRM snapshots
-              the last vblank count when the ioctl is called with the
-              _DRM_PRE_MODESET command, so that the counter won't go backwards
-              (which is dealt with when _DRM_POST_MODESET is used).
-            </para>
-          </listitem>
-        </varlistentry>
-      </variablelist>
-<!--!Edrivers/char/drm/drm_irq.c-->
+      The CRTC, encoder and connector functions provided by the drivers
+      implement the DRM API. They're called by the DRM core and ioctl handlers
+      to handle device state changes and configuration request. As implementing
+      those functions often requires logic not specific to drivers, mid-layer
+      helper functions are available to avoid duplicating boilerplate code.
+    </para>
+    <para>
+      The DRM core contains one mid-layer implementation. The mid-layer provides
+      implementations of several CRTC, encoder and connector functions (called
+      from the top of the mid-layer) that pre-process requests and call
+      lower-level functions provided by the driver (at the bottom of the
+      mid-layer). For instance, the
+      <function>drm_crtc_helper_set_config</function> function can be used to
+      fill the struct <structname>drm_crtc_funcs</structname>
+      <structfield>set_config</structfield> field. When called, it will split
+      the <methodname>set_config</methodname> operation in smaller, simpler
+      operations and call the driver to handle them.
     </para>
     <para>
-      To support the functions above, the DRM core provides several
-      helper functions for tracking vertical blank counters, and
-      requires drivers to provide several callbacks:
-      get_vblank_counter(), enable_vblank() and disable_vblank().  The
-      core uses get_vblank_counter() to keep the counter accurate
-      across interrupt disable periods.  It should return the current
-      vertical blank event count, which is often tracked in a device
-      register.  The enable and disable vblank callbacks should enable
-      and disable vertical blank interrupts, respectively.  In the
-      absence of DRM clients waiting on vblank events, the core DRM
-      code uses the disable_vblank() function to disable
-      interrupts, which saves power.  They are re-enabled again when
-      a client calls the vblank wait ioctl above.
+      To use the mid-layer, drivers call <function>drm_crtc_helper_add</function>,
+      <function>drm_encoder_helper_add</function> and
+      <function>drm_connector_helper_add</function> functions to install their
+      mid-layer bottom operations handlers, and fill the
+      <structname>drm_crtc_funcs</structname>,
+      <structname>drm_encoder_funcs</structname> and
+      <structname>drm_connector_funcs</structname> structures with pointers to
+      the mid-layer top API functions. Installing the mid-layer bottom operation
+      handlers is best done right after registering the corresponding KMS object.
     </para>
     <para>
-      A device that doesn't provide a count register may simply use an
-      internal atomic counter incremented on every vertical blank
-      interrupt (and then treat the enable_vblank() and disable_vblank()
-      callbacks as no-ops).
+      The mid-layer is not split between CRTC, encoder and connector operations.
+      To use it, a driver must provide bottom functions for all of the three KMS
+      entities.
     </para>
+    <sect2>
+      <title>Helper Functions</title>
+      <itemizedlist>
+        <listitem>
+          <synopsis>int drm_crtc_helper_set_config(struct drm_mode_set *set);</synopsis>
+          <para>
+            The <function>drm_crtc_helper_set_config</function> helper function
+            is a CRTC <methodname>set_config</methodname> implementation. It
+            first tries to locate the best encoder for each connector by calling
+            the connector <methodname>best_encoder</methodname> helper
+            operation.
+          </para>
+          <para>
+            After locating the appropriate encoders, the helper function will
+            call the <methodname>mode_fixup</methodname> encoder and CRTC helper
+            operations to adjust the requested mode, or reject it completely in
+            which case an error will be returned to the application. If the new
+            configuration after mode adjustment is identical to the current
+            configuration the helper function will return without performing any
+            other operation.
+          </para>
+          <para>
+            If the adjusted mode is identical to the current mode but changes to
+            the frame buffer need to be applied, the
+            <function>drm_crtc_helper_set_config</function> function will call
+            the CRTC <methodname>mode_set_base</methodname> helper operation. If
+            the adjusted mode differs from the current mode, or if the
+            <methodname>mode_set_base</methodname> helper operation is not
+            provided, the helper function performs a full mode set sequence by
+            calling the <methodname>prepare</methodname>,
+            <methodname>mode_set</methodname> and
+            <methodname>commit</methodname> CRTC and encoder helper operations,
+            in that order.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>void drm_helper_connector_dpms(struct drm_connector *connector, int mode);</synopsis>
+          <para>
+            The <function>drm_helper_connector_dpms</function> helper function
+            is a connector <methodname>dpms</methodname> implementation that
+            tracks power state of connectors. To use the function, drivers must
+            provide <methodname>dpms</methodname> helper operations for CRTCs
+            and encoders to apply the DPMS state to the device.
+          </para>
+          <para>
+            The mid-layer doesn't track the power state of CRTCs and encoders.
+            The <methodname>dpms</methodname> helper operations can thus be
+            called with a mode identical to the currently active mode.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
+                                            uint32_t maxX, uint32_t maxY);</synopsis>
+          <para>
+            The <function>drm_helper_probe_single_connector_modes</function> helper
+            function is a connector <methodname>fill_modes</methodname>
+            implementation that updates the connection status for the connector
+            and then retrieves a list of modes by calling the connector
+            <methodname>get_modes</methodname> helper operation.
+          </para>
+          <para>
+            The function filters out modes larger than
+            <parameter>max_width</parameter> and <parameter>max_height</parameter>
+            if specified. It then calls the connector
+            <methodname>mode_valid</methodname> helper operation for  each mode in
+            the probed list to check whether the mode is valid for the connector.
+          </para>
+        </listitem>
+      </itemizedlist>
+    </sect2>
+    <sect2>
+      <title>CRTC Helper Operations</title>
+      <itemizedlist>
+        <listitem id="drm-helper-crtc-mode-fixup">
+          <synopsis>bool (*mode_fixup)(struct drm_crtc *crtc,
+                       const struct drm_display_mode *mode,
+                       struct drm_display_mode *adjusted_mode);</synopsis>
+          <para>
+            Let CRTCs adjust the requested mode or reject it completely. This
+            operation returns true if the mode is accepted (possibly after being
+            adjusted) or false if it is rejected.
+          </para>
+          <para>
+            The <methodname>mode_fixup</methodname> operation should reject the
+            mode if it can't reasonably use it. The definition of "reasonable"
+            is currently fuzzy in this context. One possible behaviour would be
+            to set the adjusted mode to the panel timings when a fixed-mode
+            panel is used with hardware capable of scaling. Another behaviour
+            would be to accept any input mode and adjust it to the closest mode
+            supported by the hardware (FIXME: This needs to be clarified).
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>int (*mode_set_base)(struct drm_crtc *crtc, int x, int y,
+                     struct drm_framebuffer *old_fb)</synopsis>
+          <para>
+            Move the CRTC on the current frame buffer (stored in
+            <literal>crtc-&gt;fb</literal>) to position (x,y). Any of the frame
+            buffer, x position or y position may have been modified.
+          </para>
+          <para>
+            This helper operation is optional. If not provided, the
+            <function>drm_crtc_helper_set_config</function> function will fall
+            back to the <methodname>mode_set</methodname> helper operation.
+          </para>
+          <note><para>
+            FIXME: Why are x and y passed as arguments, as they can be accessed
+            through <literal>crtc-&gt;x</literal> and
+            <literal>crtc-&gt;y</literal>?
+          </para></note>
+        </listitem>
+        <listitem>
+          <synopsis>void (*prepare)(struct drm_crtc *crtc);</synopsis>
+          <para>
+            Prepare the CRTC for mode setting. This operation is called after
+            validating the requested mode. Drivers use it to perform
+            device-specific operations required before setting the new mode.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>int (*mode_set)(struct drm_crtc *crtc, struct drm_display_mode *mode,
+                struct drm_display_mode *adjusted_mode, int x, int y,
+                struct drm_framebuffer *old_fb);</synopsis>
+          <para>
+            Set a new mode, position and frame buffer. Depending on the device
+            requirements, the mode can be stored internally by the driver and
+            applied in the <methodname>commit</methodname> operation, or
+            programmed to the hardware immediately.
+          </para>
+          <para>
+            The <methodname>mode_set</methodname> operation returns 0 on success
+	    or a negative error code if an error occurs.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>void (*commit)(struct drm_crtc *crtc);</synopsis>
+          <para>
+            Commit a mode. This operation is called after setting the new mode.
+            Upon return the device must use the new mode and be fully
+            operational.
+          </para>
+        </listitem>
+      </itemizedlist>
+    </sect2>
+    <sect2>
+      <title>Encoder Helper Operations</title>
+      <itemizedlist>
+        <listitem>
+          <synopsis>bool (*mode_fixup)(struct drm_encoder *encoder,
+                       const struct drm_display_mode *mode,
+                       struct drm_display_mode *adjusted_mode);</synopsis>
+          <note><para>
+            FIXME: The mode argument be const, but the i915 driver modifies
+            mode-&gt;clock in <function>intel_dp_mode_fixup</function>.
+          </para></note>
+          <para>
+            Let encoders adjust the requested mode or reject it completely. This
+            operation returns true if the mode is accepted (possibly after being
+            adjusted) or false if it is rejected. See the
+            <link linkend="drm-helper-crtc-mode-fixup">mode_fixup CRTC helper
+            operation</link> for an explanation of the allowed adjustments.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>void (*prepare)(struct drm_encoder *encoder);</synopsis>
+          <para>
+            Prepare the encoder for mode setting. This operation is called after
+            validating the requested mode. Drivers use it to perform
+            device-specific operations required before setting the new mode.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>void (*mode_set)(struct drm_encoder *encoder,
+                 struct drm_display_mode *mode,
+                 struct drm_display_mode *adjusted_mode);</synopsis>
+          <para>
+            Set a new mode. Depending on the device requirements, the mode can
+            be stored internally by the driver and applied in the
+            <methodname>commit</methodname> operation, or programmed to the
+            hardware immediately.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>void (*commit)(struct drm_encoder *encoder);</synopsis>
+          <para>
+            Commit a mode. This operation is called after setting the new mode.
+            Upon return the device must use the new mode and be fully
+            operational.
+          </para>
+        </listitem>
+      </itemizedlist>
+    </sect2>
+    <sect2>
+      <title>Connector Helper Operations</title>
+      <itemizedlist>
+        <listitem>
+          <synopsis>struct drm_encoder *(*best_encoder)(struct drm_connector *connector);</synopsis>
+          <para>
+            Return a pointer to the best encoder for the connecter. Device that
+            map connectors to encoders 1:1 simply return the pointer to the
+            associated encoder. This operation is mandatory.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>int (*get_modes)(struct drm_connector *connector);</synopsis>
+          <para>
+            Fill the connector's <structfield>probed_modes</structfield> list
+            by parsing EDID data with <function>drm_add_edid_modes</function> or
+            calling <function>drm_mode_probed_add</function> directly for every
+            supported mode and return the number of modes it has detected. This
+            operation is mandatory.
+          </para>
+          <para>
+            When adding modes manually the driver creates each mode with a call to
+            <function>drm_mode_create</function> and must fill the following fields.
+            <itemizedlist>
+              <listitem>
+                <synopsis>__u32 type;</synopsis>
+                <para>
+                  Mode type bitmask, a combination of
+                  <variablelist>
+                    <varlistentry>
+                      <term>DRM_MODE_TYPE_BUILTIN</term>
+                      <listitem><para>not used?</para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_TYPE_CLOCK_C</term>
+                      <listitem><para>not used?</para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_TYPE_CRTC_C</term>
+                      <listitem><para>not used?</para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>
+        DRM_MODE_TYPE_PREFERRED - The preferred mode for the connector
+                      </term>
+                      <listitem>
+                        <para>not used?</para>
+                      </listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_TYPE_DEFAULT</term>
+                      <listitem><para>not used?</para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_TYPE_USERDEF</term>
+                      <listitem><para>not used?</para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_TYPE_DRIVER</term>
+                      <listitem>
+                        <para>
+                          The mode has been created by the driver (as opposed to
+                          to user-created modes).
+                        </para>
+                      </listitem>
+                    </varlistentry>
+                  </variablelist>
+                  Drivers must set the DRM_MODE_TYPE_DRIVER bit for all modes they
+                  create, and set the DRM_MODE_TYPE_PREFERRED bit for the preferred
+                  mode.
+                </para>
+              </listitem>
+              <listitem>
+                <synopsis>__u32 clock;</synopsis>
+                <para>Pixel clock frequency in kHz unit</para>
+              </listitem>
+              <listitem>
+                <synopsis>__u16 hdisplay, hsync_start, hsync_end, htotal;
+    __u16 vdisplay, vsync_start, vsync_end, vtotal;</synopsis>
+                <para>Horizontal and vertical timing information</para>
+                <screen><![CDATA[
+             Active                 Front           Sync           Back
+             Region                 Porch                          Porch
+    <-----------------------><----------------><-------------><-------------->
+
+      //////////////////////|
+     ////////////////////// |
+    //////////////////////  |..................               ................
+                                               _______________
+
+    <----- [hv]display ----->
+    <------------- [hv]sync_start ------------>
+    <--------------------- [hv]sync_end --------------------->
+    <-------------------------------- [hv]total ----------------------------->
+]]></screen>
+              </listitem>
+              <listitem>
+                <synopsis>__u16 hskew;
+    __u16 vscan;</synopsis>
+                <para>Unknown</para>
+              </listitem>
+              <listitem>
+                <synopsis>__u32 flags;</synopsis>
+                <para>
+                  Mode flags, a combination of
+                  <variablelist>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_PHSYNC</term>
+                      <listitem><para>
+                        Horizontal sync is active high
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_NHSYNC</term>
+                      <listitem><para>
+                        Horizontal sync is active low
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_PVSYNC</term>
+                      <listitem><para>
+                        Vertical sync is active high
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_NVSYNC</term>
+                      <listitem><para>
+                        Vertical sync is active low
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_INTERLACE</term>
+                      <listitem><para>
+                        Mode is interlaced
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_DBLSCAN</term>
+                      <listitem><para>
+                        Mode uses doublescan
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_CSYNC</term>
+                      <listitem><para>
+                        Mode uses composite sync
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_PCSYNC</term>
+                      <listitem><para>
+                        Composite sync is active high
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_NCSYNC</term>
+                      <listitem><para>
+                        Composite sync is active low
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_HSKEW</term>
+                      <listitem><para>
+                        hskew provided (not used?)
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_BCAST</term>
+                      <listitem><para>
+                        not used?
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_PIXMUX</term>
+                      <listitem><para>
+                        not used?
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_DBLCLK</term>
+                      <listitem><para>
+                        not used?
+                      </para></listitem>
+                    </varlistentry>
+                    <varlistentry>
+                      <term>DRM_MODE_FLAG_CLKDIV2</term>
+                      <listitem><para>
+                        ?
+                      </para></listitem>
+                    </varlistentry>
+                  </variablelist>
+                </para>
+                <para>
+                  Note that modes marked with the INTERLACE or DBLSCAN flags will be
+                  filtered out by
+                  <function>drm_helper_probe_single_connector_modes</function> if
+                  the connector's <structfield>interlace_allowed</structfield> or
+                  <structfield>doublescan_allowed</structfield> field is set to 0.
+                </para>
+              </listitem>
+              <listitem>
+                <synopsis>char name[DRM_DISPLAY_MODE_LEN];</synopsis>
+                <para>
+                  Mode name. The driver must call
+                  <function>drm_mode_set_name</function> to fill the mode name from
+                  <structfield>hdisplay</structfield>,
+                  <structfield>vdisplay</structfield> and interlace flag after
+                  filling the corresponding fields.
+                </para>
+              </listitem>
+            </itemizedlist>
+          </para>
+          <para>
+            The <structfield>vrefresh</structfield> value is computed by
+            <function>drm_helper_probe_single_connector_modes</function>.
+          </para>
+          <para>
+            When parsing EDID data, <function>drm_add_edid_modes</function> fill the
+            connector <structfield>display_info</structfield>
+            <structfield>width_mm</structfield> and
+            <structfield>height_mm</structfield> fields. When creating modes
+            manually the <methodname>get_modes</methodname> helper operation must
+            set the <structfield>display_info</structfield>
+            <structfield>width_mm</structfield> and
+            <structfield>height_mm</structfield> fields if they haven't been set
+            already (for instance at initilization time when a fixed-size panel is
+            attached to the connector). The mode <structfield>width_mm</structfield>
+            and <structfield>height_mm</structfield> fields are only used internally
+            during EDID parsing and should not be set when creating modes manually.
+          </para>
+        </listitem>
+        <listitem>
+          <synopsis>int (*mode_valid)(struct drm_connector *connector,
+		  struct drm_display_mode *mode);</synopsis>
+          <para>
+            Verify whether a mode is valid for the connector. Return MODE_OK for
+            supported modes and one of the enum drm_mode_status values (MODE_*)
+            for unsupported modes. This operation is mandatory.
+          </para>
+          <para>
+            As the mode rejection reason is currently not used beside for
+            immediately removing the unsupported mode, an implementation can
+            return MODE_BAD regardless of the exact reason why the mode is not
+            valid.
+          </para>
+          <note><para>
+            Note that the <methodname>mode_valid</methodname> helper operation is
+            only called for modes detected by the device, and
+            <emphasis>not</emphasis> for modes set by the user through the CRTC
+            <methodname>set_config</methodname> operation.
+          </para></note>
+        </listitem>
+      </itemizedlist>
+    </sect2>
   </sect1>
 
-  <sect1>
-    <title>Memory management</title>
+  <!-- Internals: vertical blanking -->
+
+  <sect1 id="drm-vertical-blank">
+    <title>Vertical Blanking</title>
+    <para>
+      Vertical blanking plays a major role in graphics rendering. To achieve
+      tear-free display, users must synchronize page flips and/or rendering to
+      vertical blanking. The DRM API offers ioctls to perform page flips
+      synchronized to vertical blanking and wait for vertical blanking.
+    </para>
+    <para>
+      The DRM core handles most of the vertical blanking management logic, which
+      involves filtering out spurious interrupts, keeping race-free blanking
+      counters, coping with counter wrap-around and resets and keeping use
+      counts. It relies on the driver to generate vertical blanking interrupts
+      and optionally provide a hardware vertical blanking counter. Drivers must
+      implement the following operations.
+    </para>
+    <itemizedlist>
+      <listitem>
+        <synopsis>int (*enable_vblank) (struct drm_device *dev, int crtc);
+void (*disable_vblank) (struct drm_device *dev, int crtc);</synopsis>
+        <para>
+	  Enable or disable vertical blanking interrupts for the given CRTC.
+	</para>
+      </listitem>
+      <listitem>
+        <synopsis>u32 (*get_vblank_counter) (struct drm_device *dev, int crtc);</synopsis>
+        <para>
+	  Retrieve the value of the vertical blanking counter for the given
+	  CRTC. If the hardware maintains a vertical blanking counter its value
+	  should be returned. Otherwise drivers can use the
+	  <function>drm_vblank_count</function> helper function to handle this
+	  operation.
+	</para>
+      </listitem>
+    </itemizedlist>
     <para>
-      The memory manager lies at the heart of many DRM operations; it
-      is required to support advanced client features like OpenGL
-      pbuffers.  The DRM currently contains two memory managers: TTM
-      and GEM.
+      Drivers must initialize the vertical blanking handling core with a call to
+      <function>drm_vblank_init</function> in their
+      <methodname>load</methodname> operation. The function will set the struct
+      <structname>drm_device</structname>
+      <structfield>vblank_disable_allowed</structfield> field to 0. This will
+      keep vertical blanking interrupts enabled permanently until the first mode
+      set operation, where <structfield>vblank_disable_allowed</structfield> is
+      set to 1. The reason behind this is not clear. Drivers can set the field
+      to 1 after <function>calling drm_vblank_init</function> to make vertical
+      blanking interrupts dynamically managed from the beginning.
     </para>
+    <para>
+      Vertical blanking interrupts can be enabled by the DRM core or by drivers
+      themselves (for instance to handle page flipping operations). The DRM core
+      maintains a vertical blanking use count to ensure that the interrupts are
+      not disabled while a user still needs them. To increment the use count,
+      drivers call <function>drm_vblank_get</function>. Upon return vertical
+      blanking interrupts are guaranteed to be enabled.
+    </para>
+    <para>
+      To decrement the use count drivers call
+      <function>drm_vblank_put</function>. Only when the use count drops to zero
+      will the DRM core disable the vertical blanking interrupts after a delay
+      by scheduling a timer. The delay is accessible through the vblankoffdelay
+      module parameter or the <varname>drm_vblank_offdelay</varname> global
+      variable and expressed in milliseconds. Its default value is 5000 ms.
+    </para>
+    <para>
+      When a vertical blanking interrupt occurs drivers only need to call the
+      <function>drm_handle_vblank</function> function to account for the
+      interrupt.
+    </para>
+    <para>
+      Resources allocated by <function>drm_vblank_init</function> must be freed
+      with a call to <function>drm_vblank_cleanup</function> in the driver
+      <methodname>unload</methodname> operation handler.
+    </para>
+  </sect1>
+
+  <!-- Internals: open/close, file operations and ioctls -->
 
+  <sect1>
+    <title>Open/Close, File Operations and IOCTLs</title>
     <sect2>
-      <title>The Translation Table Manager (TTM)</title>
+      <title>Open and Close</title>
+      <synopsis>int (*firstopen) (struct drm_device *);
+void (*lastclose) (struct drm_device *);
+int (*open) (struct drm_device *, struct drm_file *);
+void (*preclose) (struct drm_device *, struct drm_file *);
+void (*postclose) (struct drm_device *, struct drm_file *);</synopsis>
+      <abstract>Open and close handlers. None of those methods are mandatory.
+      </abstract>
       <para>
-	TTM was developed by Tungsten Graphics, primarily by Thomas
-	Hellström, and is intended to be a flexible, high performance
-	graphics memory manager.
+        The <methodname>firstopen</methodname> method is called by the DRM core
+	when an application opens a device that has no other opened file handle.
+	Similarly the <methodname>lastclose</methodname> method is called when
+	the last application holding a file handle opened on the device closes
+	it. Both methods are mostly used for UMS (User Mode Setting) drivers to
+	acquire and release device resources which should be done in the
+	<methodname>load</methodname> and <methodname>unload</methodname>
+	methods for KMS drivers.
       </para>
       <para>
-	Drivers wishing to support TTM must fill out a drm_bo_driver
-	structure.
+        Note that the <methodname>lastclose</methodname> method is also called
+	at module unload time or, for hot-pluggable devices, when the device is
+	unplugged. The <methodname>firstopen</methodname> and
+	<methodname>lastclose</methodname> calls can thus be unbalanced.
       </para>
       <para>
-	TTM design background and information belongs here.
+        The <methodname>open</methodname> method is called every time the device
+	is opened by an application. Drivers can allocate per-file private data
+	in this method and store them in the struct
+	<structname>drm_file</structname> <structfield>driver_priv</structfield>
+	field. Note that the <methodname>open</methodname> method is called
+	before <methodname>firstopen</methodname>.
+      </para>
+      <para>
+        The close operation is split into <methodname>preclose</methodname> and
+	<methodname>postclose</methodname> methods. Drivers must stop and
+	cleanup all per-file operations in the <methodname>preclose</methodname>
+	method. For instance pending vertical blanking and page flip events must
+	be cancelled. No per-file operation is allowed on the file handle after
+	returning from the <methodname>preclose</methodname> method.
+      </para>
+      <para>
+        Finally the <methodname>postclose</methodname> method is called as the
+	last step of the close operation, right before calling the
+	<methodname>lastclose</methodname> method if no other open file handle
+	exists for the device. Drivers that have allocated per-file private data
+	in the <methodname>open</methodname> method should free it here.
+      </para>
+      <para>
+        The <methodname>lastclose</methodname> method should restore CRTC and
+	plane properties to default value, so that a subsequent open of the
+	device will not inherit state from the previous user.
       </para>
     </sect2>
-
     <sect2>
-      <title>The Graphics Execution Manager (GEM)</title>
+      <title>File Operations</title>
+      <synopsis>const struct file_operations *fops</synopsis>
+      <abstract>File operations for the DRM device node.</abstract>
       <para>
-	GEM is an Intel project, authored by Eric Anholt and Keith
-	Packard.  It provides simpler interfaces than TTM, and is well
-	suited for UMA devices.
+        Drivers must define the file operations structure that forms the DRM
+	userspace API entry point, even though most of those operations are
+	implemented in the DRM core. The <methodname>open</methodname>,
+	<methodname>release</methodname> and <methodname>ioctl</methodname>
+	operations are handled by
+	<programlisting>
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.release = drm_release,
+	.unlocked_ioctl = drm_ioctl,
+  #ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+  #endif
+        </programlisting>
       </para>
       <para>
-	GEM-enabled drivers must provide gem_init_object() and
-	gem_free_object() callbacks to support the core memory
-	allocation routines.  They should also provide several driver-specific
-	ioctls to support command execution, pinning, buffer
-	read &amp; write, mapping, and domain ownership transfers.
+        Drivers that implement private ioctls that requires 32/64bit
+	compatibility support must provide their own
+	<methodname>compat_ioctl</methodname> handler that processes private
+	ioctls and calls <function>drm_compat_ioctl</function> for core ioctls.
       </para>
       <para>
-	On a fundamental level, GEM involves several operations:
-	<itemizedlist>
-	  <listitem>Memory allocation and freeing</listitem>
-	  <listitem>Command execution</listitem>
-	  <listitem>Aperture management at command execution time</listitem>
-	</itemizedlist>
-	Buffer object allocation is relatively
-	straightforward and largely provided by Linux's shmem layer, which
-	provides memory to back each object.  When mapped into the GTT
-	or used in a command buffer, the backing pages for an object are
-	flushed to memory and marked write combined so as to be coherent
-	with the GPU.  Likewise, if the CPU accesses an object after the GPU
-	has finished rendering to the object, then the object must be made
-	coherent with the CPU's view
-	of memory, usually involving GPU cache flushing of various kinds.
-	This core CPU&lt;-&gt;GPU coherency management is provided by a
-	device-specific ioctl, which evaluates an object's current domain and
-	performs any necessary flushing or synchronization to put the object
-	into the desired coherency domain (note that the object may be busy,
-	i.e. an active render target; in that case, setting the domain
-	blocks the client and waits for rendering to complete before
-	performing any necessary flushing operations).
-      </para>
-      <para>
-	Perhaps the most important GEM function is providing a command
-	execution interface to clients.  Client programs construct command
-	buffers containing references to previously allocated memory objects,
-	and then submit them to GEM.  At that point, GEM takes care to bind
-	all the objects into the GTT, execute the buffer, and provide
-	necessary synchronization between clients accessing the same buffers.
-	This often involves evicting some objects from the GTT and re-binding
-	others (a fairly expensive operation), and providing relocation
-	support which hides fixed GTT offsets from clients.  Clients must
-	take care not to submit command buffers that reference more objects
-	than can fit in the GTT; otherwise, GEM will reject them and no rendering
-	will occur.  Similarly, if several objects in the buffer require
-	fence registers to be allocated for correct rendering (e.g. 2D blits
-	on pre-965 chips), care must be taken not to require more fence
-	registers than are available to the client.  Such resource management
-	should be abstracted from the client in libdrm.
+        The <methodname>read</methodname> and <methodname>poll</methodname>
+	operations provide support for reading DRM events and polling them. They
+	are implemented by
+	<programlisting>
+	.poll = drm_poll,
+	.read = drm_read,
+	.fasync = drm_fasync,
+	.llseek = no_llseek,
+	</programlisting>
+      </para>
+      <para>
+        The memory mapping implementation varies depending on how the driver
+	manages memory. Pre-GEM drivers will use <function>drm_mmap</function>,
+	while GEM-aware drivers will use <function>drm_gem_mmap</function>. See
+	<xref linkend="drm-gem"/>.
+	<programlisting>
+	.mmap = drm_gem_mmap,
+	</programlisting>
+      </para>
+      <para>
+        No other file operation is supported by the DRM API.
+      </para>
+    </sect2>
+    <sect2>
+      <title>IOCTLs</title>
+      <synopsis>struct drm_ioctl_desc *ioctls;
+int num_ioctls;</synopsis>
+      <abstract>Driver-specific ioctls descriptors table.</abstract>
+      <para>
+        Driver-specific ioctls numbers start at DRM_COMMAND_BASE. The ioctls
+	descriptors table is indexed by the ioctl number offset from the base
+	value. Drivers can use the DRM_IOCTL_DEF_DRV() macro to initialize the
+	table entries.
+      </para>
+      <para>
+        <programlisting>DRM_IOCTL_DEF_DRV(ioctl, func, flags)</programlisting>
+	<para>
+	  <parameter>ioctl</parameter> is the ioctl name. Drivers must define
+	  the DRM_##ioctl and DRM_IOCTL_##ioctl macros to the ioctl number
+	  offset from DRM_COMMAND_BASE and the ioctl number respectively. The
+	  first macro is private to the device while the second must be exposed
+	  to userspace in a public header.
+	</para>
+	<para>
+	  <parameter>func</parameter> is a pointer to the ioctl handler function
+	  compatible with the <type>drm_ioctl_t</type> type.
+	  <programlisting>typedef int drm_ioctl_t(struct drm_device *dev, void *data,
+		struct drm_file *file_priv);</programlisting>
+	</para>
+	<para>
+	  <parameter>flags</parameter> is a bitmask combination of the following
+	  values. It restricts how the ioctl is allowed to be called.
+	  <itemizedlist>
+	    <listitem><para>
+	      DRM_AUTH - Only authenticated callers allowed
+	    </para></listitem>
+	    <listitem><para>
+	      DRM_MASTER - The ioctl can only be called on the master file
+	      handle
+	    </para></listitem>
+            <listitem><para>
+	      DRM_ROOT_ONLY - Only callers with the SYSADMIN capability allowed
+	    </para></listitem>
+            <listitem><para>
+	      DRM_CONTROL_ALLOW - The ioctl can only be called on a control
+	      device
+	    </para></listitem>
+            <listitem><para>
+	      DRM_UNLOCKED - The ioctl handler will be called without locking
+	      the DRM global mutex
+	    </para></listitem>
+	  </itemizedlist>
+	</para>
       </para>
     </sect2>
-
-  </sect1>
-
-  <!-- Output management -->
-  <sect1>
-    <title>Output management</title>
-    <para>
-      At the core of the DRM output management code is a set of
-      structures representing CRTCs, encoders, and connectors.
-    </para>
-    <para>
-      A CRTC is an abstraction representing a part of the chip that
-      contains a pointer to a scanout buffer.  Therefore, the number
-      of CRTCs available determines how many independent scanout
-      buffers can be active at any given time.  The CRTC structure
-      contains several fields to support this: a pointer to some video
-      memory, a display mode, and an (x, y) offset into the video
-      memory to support panning or configurations where one piece of
-      video memory spans multiple CRTCs.
-    </para>
-    <para>
-      An encoder takes pixel data from a CRTC and converts it to a
-      format suitable for any attached connectors.  On some devices,
-      it may be possible to have a CRTC send data to more than one
-      encoder.  In that case, both encoders would receive data from
-      the same scanout buffer, resulting in a "cloned" display
-      configuration across the connectors attached to each encoder.
-    </para>
-    <para>
-      A connector is the final destination for pixel data on a device,
-      and usually connects directly to an external display device like
-      a monitor or laptop panel.  A connector can only be attached to
-      one encoder at a time.  The connector is also the structure
-      where information about the attached display is kept, so it
-      contains fields for display data, EDID data, DPMS &amp;
-      connection status, and information about modes supported on the
-      attached displays.
-    </para>
-<!--!Edrivers/char/drm/drm_crtc.c-->
-  </sect1>
-
-  <sect1>
-    <title>Framebuffer management</title>
-    <para>
-      Clients need to provide a framebuffer object which provides a source
-      of pixels for a CRTC to deliver to the encoder(s) and ultimately the
-      connector(s). A framebuffer is fundamentally a driver-specific memory
-      object, made into an opaque handle by the DRM's addfb() function.
-      Once a framebuffer has been created this way, it may be passed to the
-      KMS mode setting routines for use in a completed configuration.
-    </para>
   </sect1>
 
   <sect1>
@@ -812,15 +2355,24 @@ void intel_crt_init(struct drm_device *dev)
     </para>
   </sect1>
 
+  <!-- Internals: suspend/resume -->
+
   <sect1>
-    <title>Suspend/resume</title>
+    <title>Suspend/Resume</title>
+    <para>
+      The DRM core provides some suspend/resume code, but drivers wanting full
+      suspend/resume support should provide save() and restore() functions.
+      These are called at suspend, hibernate, or resume time, and should perform
+      any state save or restore required by your device across suspend or
+      hibernate states.
+    </para>
+    <synopsis>int (*suspend) (struct drm_device *, pm_message_t state);
+int (*resume) (struct drm_device *);</synopsis>
     <para>
-      The DRM core provides some suspend/resume code, but drivers
-      wanting full suspend/resume support should provide save() and
-      restore() functions.  These are called at suspend,
-      hibernate, or resume time, and should perform any state save or
-      restore required by your device across suspend or hibernate
-      states.
+      Those are legacy suspend and resume methods. New driver should use the
+      power management interface provided by their bus type (usually through
+      the struct <structname>device_driver</structname> dev_pm_ops) and set
+      these methods to NULL.
     </para>
   </sect1>
 
@@ -833,6 +2385,35 @@ void intel_crt_init(struct drm_device *dev)
   </sect1>
   </chapter>
 
+<!-- TODO
+
+- Add a glossary
+- Document the struct_mutex catch-all lock
+- Document connector properties
+
+- Why is the load method optional?
+- What are drivers supposed to set the initial display state to, and how?
+  Connector's DPMS states are not initialized and are thus equal to
+  DRM_MODE_DPMS_ON. The fbcon compatibility layer calls
+  drm_helper_disable_unused_functions(), which disables unused encoders and
+  CRTCs, but doesn't touch the connectors' DPMS state, and
+  drm_helper_connector_dpms() in reaction to fbdev blanking events. Do drivers
+  that don't implement (or just don't use) fbcon compatibility need to call
+  those functions themselves?
+- KMS drivers must call drm_vblank_pre_modeset() and drm_vblank_post_modeset()
+  around mode setting. Should this be done in the DRM core?
+- vblank_disable_allowed is set to 1 in the first drm_vblank_post_modeset()
+  call and never set back to 0. It seems to be safe to permanently set it to 1
+  in drm_vblank_init() for KMS driver, and it might be safe for UMS drivers as
+  well. This should be investigated.
+- crtc and connector .save and .restore operations are only used internally in
+  drivers, should they be removed from the core?
+- encoder mid-layer .save and .restore operations are only used internally in
+  drivers, should they be removed from the core?
+- encoder mid-layer .detect operation is only used internally in drivers,
+  should it be removed from the core?
+-->
+
   <!-- External interfaces -->
 
   <chapter id="drmExternals">
@@ -853,6 +2434,42 @@ void intel_crt_init(struct drm_device *dev)
       Cover generic ioctls and sysfs layout here.  We only need high-level
       info, since man pages should cover the rest.
     </para>
+
+  <!-- External: vblank handling -->
+
+    <sect1>
+      <title>VBlank event handling</title>
+      <para>
+        The DRM core exposes two vertical blank related ioctls:
+        <variablelist>
+          <varlistentry>
+            <term>DRM_IOCTL_WAIT_VBLANK</term>
+            <listitem>
+              <para>
+                This takes a struct drm_wait_vblank structure as its argument,
+                and it is used to block or request a signal when a specified
+                vblank event occurs.
+              </para>
+            </listitem>
+          </varlistentry>
+          <varlistentry>
+            <term>DRM_IOCTL_MODESET_CTL</term>
+            <listitem>
+              <para>
+                This should be called by application level drivers before and
+                after mode setting, since on many devices the vertical blank
+                counter is reset at that time.  Internally, the DRM snapshots
+                the last vblank count when the ioctl is called with the
+                _DRM_PRE_MODESET command, so that the counter won't go backwards
+                (which is dealt with when _DRM_POST_MODESET is used).
+              </para>
+            </listitem>
+          </varlistentry>
+        </variablelist>
+<!--!Edrivers/char/drm/drm_irq.c-->
+      </para>
+    </sect1>
+
   </chapter>
 
   <!-- API reference -->
-- 
Regards,

Laurent Pinchart

